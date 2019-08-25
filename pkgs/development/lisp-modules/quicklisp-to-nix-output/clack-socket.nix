args @ { fetchurl, ... }:
rec {
  baseName = ''clack-socket'';
  version = ''clack-20190710-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2019-07-10/clack-20190710-git.tgz'';
    sha256 = ''1642myknfaajcyqllnhn9s17yb6dbj1yh9wmg1kbplwq9c3yjs7k'';
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION NIL SHA256
    1642myknfaajcyqllnhn9s17yb6dbj1yh9wmg1kbplwq9c3yjs7k URL
    http://beta.quicklisp.org/archive/clack/2019-07-10/clack-20190710-git.tgz
    MD5 9d8869ca599652d68dd759c8a6adcd3d NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20190710-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack-v1-compat clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
