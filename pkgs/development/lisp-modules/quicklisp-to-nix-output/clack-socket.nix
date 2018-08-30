{ fetchurl, ... }:
rec {
  baseName = ''clack-socket'';
  version = ''clack-20180328-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2018-03-28/clack-20180328-git.tgz'';
    sha256 = ''1appp17m7b5laxwgnidf9kral1476nl394mm10xzi1c0i18rssai'';
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION NIL SHA256
    1appp17m7b5laxwgnidf9kral1476nl394mm10xzi1c0i18rssai URL
    http://beta.quicklisp.org/archive/clack/2018-03-28/clack-20180328-git.tgz
    MD5 5cf75a5d908efcd779438dc13f917d57 NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20180328-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack-v1-compat clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
