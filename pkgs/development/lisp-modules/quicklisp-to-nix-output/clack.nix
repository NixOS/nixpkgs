/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack";
  version = "20210411-git";

  description = "Web application environment for Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."ironclad" args."lack" args."lack-component" args."lack-middleware-backtrace" args."lack-util" args."split-sequence" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2021-04-11/clack-20210411-git.tgz";
    sha256 = "0yai9cx1gha684ljr8k1s5n4mi6mpj2wmvv6b9iw7pw1vhw5m8mf";
  };

  packageName = "clack";

  asdFilesToKeep = ["clack.asd"];
  overrides = x: x;
}
/* (SYSTEM clack DESCRIPTION Web application environment for Common Lisp SHA256
    0yai9cx1gha684ljr8k1s5n4mi6mpj2wmvv6b9iw7pw1vhw5m8mf URL
    http://beta.quicklisp.org/archive/clack/2021-04-11/clack-20210411-git.tgz
    MD5 c47deb6287b72fc9033055914787f3a5 NAME clack FILENAME clack DEPS
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
    VERSION 20210411-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-test clack-v1-compat
     t-clack-handler-fcgi t-clack-handler-hunchentoot t-clack-handler-toot
     t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic
     clack-middleware-clsql clack-middleware-csrf clack-middleware-dbi
     clack-middleware-oauth clack-middleware-postmodern
     clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)
    PARASITES NIL) */
