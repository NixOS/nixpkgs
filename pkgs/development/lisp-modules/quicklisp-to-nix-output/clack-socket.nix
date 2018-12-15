args @ { fetchurl, ... }:
rec {
  baseName = ''clack-socket'';
  version = ''clack-20180831-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2018-08-31/clack-20180831-git.tgz'';
    sha256 = ''0pfpm3l7l47j0mmwimy7c61ym8lg5m1dkzmz394snyywzcx54647'';
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION NIL SHA256
    0pfpm3l7l47j0mmwimy7c61ym8lg5m1dkzmz394snyywzcx54647 URL
    http://beta.quicklisp.org/archive/clack/2018-08-31/clack-20180831-git.tgz
    MD5 5042ece3b0a8b07cb4b318fbc250b4fe NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20180831-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack-v1-compat clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
