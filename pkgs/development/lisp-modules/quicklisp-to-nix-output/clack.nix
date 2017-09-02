args @ { fetchurl, ... }:
rec {
  baseName = ''clack'';
  version = ''20170630-git'';

  description = ''Web application environment for Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."lack" args."lack-middleware-backtrace" args."lack-util" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz'';
    sha256 = ''1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg'';
  };

  packageName = "clack";

  asdFilesToKeep = ["clack.asd"];
  overrides = x: x;
}
/* (SYSTEM clack DESCRIPTION Web application environment for Common Lisp SHA256
    1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg URL
    http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz
    MD5 845b25a3cc6f3a1ee1dbd6de73dfb815 NAME clack FILENAME clack DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME lack FILENAME lack)
     (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack-util FILENAME lack-util) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria bordeaux-threads lack lack-middleware-backtrace lack-util uiop)
    VERSION 20170630-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-test clack-v1-compat
     t-clack-handler-fcgi t-clack-handler-hunchentoot t-clack-handler-toot
     t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic
     clack-middleware-clsql clack-middleware-csrf clack-middleware-dbi
     clack-middleware-oauth clack-middleware-postmodern
     clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)
    PARASITES NIL) */
