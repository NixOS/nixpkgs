/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack";
  version = "20220220-git";

  description = "Web application environment for Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-isaac" args."lack" args."lack-component" args."lack-middleware-backtrace" args."lack-util" args."split-sequence" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2022-02-20/clack-20220220-git.tgz";
    sha256 = "1fk7apnm69hchib0gx1ipmgala53wjgwhfdwafgyl58wikhzsphf";
  };

  packageName = "clack";

  asdFilesToKeep = ["clack.asd"];
  overrides = x: x;
}
/* (SYSTEM clack DESCRIPTION Web application environment for Common Lisp SHA256
    1fk7apnm69hchib0gx1ipmgala53wjgwhfdwafgyl58wikhzsphf URL
    http://beta.quicklisp.org/archive/clack/2022-02-20/clack-20220220-git.tgz
    MD5 a74eeeebb582f3b711088254b6e256f5 NAME clack FILENAME clack DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-isaac FILENAME cl-isaac) (NAME lack FILENAME lack)
     (NAME lack-component FILENAME lack-component)
     (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack-util FILENAME lack-util)
     (NAME split-sequence FILENAME split-sequence) (NAME uiop FILENAME uiop)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-isaac lack lack-component
     lack-middleware-backtrace lack-util split-sequence uiop usocket)
    VERSION 20220220-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-test t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie)
    PARASITES NIL) */
