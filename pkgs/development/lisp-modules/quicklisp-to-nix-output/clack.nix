/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack";
  version = "20210807-git";

  description = "Web application environment for Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."ironclad" args."lack" args."lack-component" args."lack-middleware-backtrace" args."lack-util" args."split-sequence" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2021-08-07/clack-20210807-git.tgz";
    sha256 = "00bwpw04d6rri4hww9n1fa9ygvjgr5d18r7iadqwz0ns795p2pva";
  };

  packageName = "clack";

  asdFilesToKeep = ["clack.asd"];
  overrides = x: x;
}
/* (SYSTEM clack DESCRIPTION Web application environment for Common Lisp SHA256
    00bwpw04d6rri4hww9n1fa9ygvjgr5d18r7iadqwz0ns795p2pva URL
    http://beta.quicklisp.org/archive/clack/2021-08-07/clack-20210807-git.tgz
    MD5 a518c42a4d433be7da579b2d46caa438 NAME clack FILENAME clack DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME ironclad FILENAME ironclad) (NAME lack FILENAME lack)
     (NAME lack-component FILENAME lack-component)
     (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack-util FILENAME lack-util)
     (NAME split-sequence FILENAME split-sequence) (NAME uiop FILENAME uiop)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads ironclad lack lack-component
     lack-middleware-backtrace lack-util split-sequence uiop usocket)
    VERSION 20210807-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-test t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie)
    PARASITES NIL) */
