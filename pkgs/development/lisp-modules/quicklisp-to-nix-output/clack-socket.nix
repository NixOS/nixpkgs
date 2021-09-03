/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack-socket";
  version = "clack-20210411-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2021-04-11/clack-20210411-git.tgz";
    sha256 = "0yai9cx1gha684ljr8k1s5n4mi6mpj2wmvv6b9iw7pw1vhw5m8mf";
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION System lacks description SHA256
    0yai9cx1gha684ljr8k1s5n4mi6mpj2wmvv6b9iw7pw1vhw5m8mf URL
    http://beta.quicklisp.org/archive/clack/2021-04-11/clack-20210411-git.tgz
    MD5 c47deb6287b72fc9033055914787f3a5 NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20210411-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack-v1-compat clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
