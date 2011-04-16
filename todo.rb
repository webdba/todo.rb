#!/usr/bin/ruby -w

###########################################################
#
#     I have not put a copyright on this because it is
#     mostly and largely based on Gina Trapani's todo.txt
#     So if this gets in the wild by mistake, then this is
#     an exercise to learn Ruby, not meant to capitalize
#     on her excellent work nor her fame.
#
###########################################################

require 'pp'
require 'sys/uname'
include Sys

VERSION = "0.5"

###########################################################
#   I am currently running Ubuntu 10.10

###########################################################
if Uname.sysname == "Linux"
    require 'fileutils'
else
    require 'ftools'
end
############################################################

########  Method Definitions ######################

#--------------------------------------  Color Routines
def rgb(red, green, blue)
  16 + (red * 36) + (green * 6) + blue
end
#--------------------------------------
def gray(g)
  232 + g
end
#--------------------------------------
def set_color(fg, bg)
  print "\x1b[38;5;#{fg}m" if fg
  print "\x1b[48;5;#{bg}m" if bg
end
#--------------------------------------
def reset_color
  print "\x1b[0m"
end
#--------------------------------------
def print_color(txt, fg, bg)
  set_color(fg, bg)
  print txt
  reset_color
end
#-------------------------------------- 
def add_task(mytask)
   fh = File.open("todo.txt","a")
   fh.puts mytask
   fh.close
   list_task()
end
#--------------------------------------
def prior_task(myline,myprior)
   myfile = File.open("todo.txt")
   newfile = File.open("todo.tmp","w")
   myfile.each {|line|
     if myfile.lineno.to_s == myline
        newfile.puts myprior + ":" + line
     else
       newfile.puts line
     end
   } 
   newfile.close
   myfile.close
   File.delete("todo.txt")
   File.rename("todo.tmp","todo.txt")
   list_task()
end
#-------------------------------------- 
def del_task(myline)
  myfile = File.open("todo.txt")
  newfile = File.open("todo.tmp","w")
  delfile = File.open("todo.del","a")
  myfile.each {|line| 
    unless myfile.lineno.to_s == myline
       newfile.puts line
    else
       delfile.puts line
    end
  }
  delfile.close
  newfile.close
  myfile.close
  File.delete("todo.txt")
  File.rename("todo.tmp","todo.txt")
  list_task()
end
#-------------------------------------- 
def list_task()
  myline=0
  ahash = Hash["A","9","B","14"]
  myalpha = Hash["A","9", "B","14","C","27","D","28","E","50","F","63", "G","71", "H","90", "I","94", "J","100", "K","106", "L","111", "M","112", "N","128",
    "O","133", "P","137", "Q","140", "R","142", "S","147", "T","11", "U","23", "V","30", "W","47", "X","57", "Y","66", "Z","150"]
  puts
  puts
  puts "--------------------------------------------------"
  f = File.open("todo.txt","r")
  f.each do |g|
      myline += 1
      ####  1, 16 = red on black
      ####  10, 16 = yellow on black
      #print_color(myline.to_s + " - " + g,46,16)

    case g
      when /:/
        cl = g[0,1] 
        lsfg = myalpha[cl]
        myg = g[2,g.size]
        print_color(myline.to_s + " - " + myg,lsfg,16)
      else
        print_color(myline.to_s + " - " + g,46,16)
    end    
  end
  f.close
  puts "--------------------------------------------------"
  puts
  puts
end
#----------------------------------------------- Read todo.txt, sort it, write back to file
def sort_task()
   farray = File.open("todo.txt").collect
   sorted_farray = farray.sort
   fh = File.open("todo_temp.tmp","w")
   sorted_farray.each do |sorted|
     fh.puts sorted
   end
   fh.close
   File.delete("todo.txt")
   File.rename("todo_temp.tmp","todo.txt")
   list_task()
end
  
#-----------------------------------------------  List Priority Tasks Only
def list_prior()
  myline=0
  puts
  puts
  puts "--------------------------------------------------"
  f = File.open("todo.txt","r")
  f.each do |g|
      myline += 1
      ####  1, 16 = red on black
      ####  10, 16 = yellow on black
      #print_color(myline.to_s + " - " + g,46,16)
      
    case g
      when /H1/
	    myg = g[3,g.size]
            print_color(myline.to_s + " - " + myg,124,16)
      when /H2/
	    myg = g[3,g.size]
            print_color(myline.to_s + " - " + myg,95,16)
      when /H3/
	    myg = g[3,g.size]
            print_color(myline.to_s + " - " + myg,137,16)
    end
  end
  f.close
  puts "--------------------------------------------------"
  puts
  puts
end
#-------------------------------------- 
def print_deleted()
  dfile = File.open("todo.del","r")
  dfile.each do |h|
    print_color(h,0,16)
  end
  dfile.close
end
#-------------------------------------- 
def show_colors()
  myloop=0
  150.times {
    print_color(myloop.to_s,myloop,16)
    myloop += 1
    print "-"
    #puts
  }
  puts
end
#--------------------------------------
def short_print_help(menufg,menubg)
       puts
       puts
       print_color("************************************************************",menufg,menubg);puts
       print_color("*            todo.rb                                       *",menufg,menubg);puts
       print_color("*                                                          *",menufg,menubg);puts
       print_color("*   A command line tool to keep a todo list                *",menufg,menubg);puts
       print_color("*   as a project list of tasks                             *",menufg,menubg);puts
       print_color("*                                                          *",menufg,menubg);puts
       print_color("*        h,help      this help page                        *",menufg,menubg);puts
       print_color("*        a,add       add a task to the list                *",menufg,menubg);puts
       print_color("*        d #         delete a task                         *",menufg,menubg);puts
       print_color("*        p # #       prioritize a task - line priority     *",menufg,menubg);puts
       print_color("*        ls          list the task list                    *",menufg,menubg);puts
       print_color("*        lsp         list the priority tasks               *",menufg,menubg);puts
       print_color("*        pd          list the deleted lines                *",menufg,menubg);puts
       print_color("*        st          sort the list                         *",menufg,menubg);puts
       print_color("*        pv          print version of todo.rb              *",menufg,menubg);puts
       print_color("*                                                          *",menufg,menubg);puts
       print_color("************************************************************",menufg,menubg);puts
       puts
       puts
end

def print_version(versionfg,versionbg)
       puts
       puts
       print_color("TODO.RB todo task list tool v$VERSION",versionfg,versionbg);puts
       print_color("Initial release March 12, 2011",versionfg,versionbg);puts
       print_color("Modeled after TODO.TXT by Gina Grapani(http://ginatrapan.org)",versionfg,versionbg);puts
       print_color("License: GPL, http://www.gnu.org/copyleft/gpl.html",versionfg,versionbg);puts
       puts
       puts
end
############# Method Definitions End

############# Main Loop

#----------------------------------------- File Checking
unless File.file?("todo.txt")
   #puts "todo.txt did not exist...creating..."
   FileUtils.touch 'todo.txt'
end

unless File.file?("todo.tmp")
   #puts "todo.tmp did not exist...creating..."
   FileUtils.touch 'todo.tmp'
end

unless File.file?("todo.del")
   #puts "todo.del did not exist...creating..."
   FileUtils.touch 'todo.del'
end

#------------------------------------------  Constants Declaration

###  Constants ###
menufg=141
menubg=16
versionfg=133
versionbg=16
mytask=""
#------------------------------------------ Command Line Processing
ARGV.each do|a|
  case a
     when "h", "-h", "--h", "-help", "--help"
       short_print_help(menufg,menubg)
       exit
     when "a", "A", "add", "Add", "ADD"
       mytask=ARGV[1] 
       #add_task(ARGV[1])
       add_task(mytask)
       exit
     when "ls", "LS"
       list_task()
       exit
     when "d", "D"
       del_task(ARGV[1])
       exit
     when "s", "S"
       show_colors()
       exit
     when "pd", "PD"
       print_deleted()
       exit
     when "p", "P"
       prior_task(ARGV[1],ARGV[2])
       exit
     when "lsp", "LSP"
       list_prior()
       exit
     when "st"
       sort_task()
       exit
     when "pv"
       print_version(versionfg,versionbg)
       exit
     else
       short_print_help(menufg,menubg)
       exit
  end
end

##########  End Main Loop

#   You should never get here
puts "wrong exit....check your GPS ;)"
exit

