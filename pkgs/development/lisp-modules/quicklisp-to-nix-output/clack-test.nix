args @ { fetchurl, ... }:
rec {
  baseName = ''clack-test'';
  version = ''clack-20170630-git'';

  description = ''Testing Clack Applications.'';

  deps = [ args."bordeaux-threads" args."clack" args."dexador" args."flexi-streams" args."http-body" args."lack" args."prove" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz'';
    sha256 = ''1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg'';
  };

  packageName = "clack-test";

  asdFilesToKeep = ["clack-test.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-test DESCRIPTION Testing Clack Applications. SHA256
    1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg URL
    http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz
    MD5 845b25a3cc6f3a1ee1dbd6de73dfb815 NAME clack-test FILENAME clack-test
    DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME clack FILENAME clack) (NAME dexador FILENAME dexador)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME http-body FILENAME http-body) (NAME lack FILENAME lack)
     (NAME prove FILENAME prove) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (bordeaux-threads clack dexador flexi-streams http-body lack prove usocket)
    VERSION clack-20170630-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-v1-compat clack
     t-clack-handler-fcgi t-clack-handler-hunchentoot t-clack-handler-toot
     t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic
     clack-middleware-clsql clack-middleware-csrf clack-middleware-dbi
     clack-middleware-oauth clack-middleware-postmodern
     clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)
    PARASITES NIL) */
