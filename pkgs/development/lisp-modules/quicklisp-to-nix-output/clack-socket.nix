args @ { fetchurl, ... }:
rec {
  baseName = ''clack-socket'';
  version = ''clack-20191007-git'';

  description = ''System lacks description'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2019-10-07/clack-20191007-git.tgz'';
    sha256 = ''004drm82mhxmcsa00lbmq2l89g4fzwn6j2drfwdazrpi27z0ry5w'';
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION System lacks description SHA256
    004drm82mhxmcsa00lbmq2l89g4fzwn6j2drfwdazrpi27z0ry5w URL
    http://beta.quicklisp.org/archive/clack/2019-10-07/clack-20191007-git.tgz
    MD5 25741855fa1e989d373ac06ddfabf351 NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20191007-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack-v1-compat clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
