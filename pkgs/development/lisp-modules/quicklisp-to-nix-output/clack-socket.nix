/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack-socket";
  version = "clack-20210807-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2021-08-07/clack-20210807-git.tgz";
    sha256 = "00bwpw04d6rri4hww9n1fa9ygvjgr5d18r7iadqwz0ns795p2pva";
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION System lacks description SHA256
    00bwpw04d6rri4hww9n1fa9ygvjgr5d18r7iadqwz0ns795p2pva URL
    http://beta.quicklisp.org/archive/clack/2021-08-07/clack-20210807-git.tgz
    MD5 a518c42a4d433be7da579b2d46caa438 NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20210807-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie)
    PARASITES NIL) */
