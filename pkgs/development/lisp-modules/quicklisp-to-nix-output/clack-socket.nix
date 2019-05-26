args @ { fetchurl, ... }:
rec {
  baseName = ''clack-socket'';
  version = ''clack-20181018-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2018-10-18/clack-20181018-git.tgz'';
    sha256 = ''1f16i1pdqkh56ahnhxni3182q089d7ya8gxv4vyczsjzw93yakcf'';
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION NIL SHA256
    1f16i1pdqkh56ahnhxni3182q089d7ya8gxv4vyczsjzw93yakcf URL
    http://beta.quicklisp.org/archive/clack/2018-10-18/clack-20181018-git.tgz
    MD5 16121d921667ee8d0d70324da7281849 NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20181018-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack-v1-compat clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
