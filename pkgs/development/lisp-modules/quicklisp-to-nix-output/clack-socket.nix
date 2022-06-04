/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack-socket";
  version = "clack-20220220-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2022-02-20/clack-20220220-git.tgz";
    sha256 = "1fk7apnm69hchib0gx1ipmgala53wjgwhfdwafgyl58wikhzsphf";
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION System lacks description SHA256
    1fk7apnm69hchib0gx1ipmgala53wjgwhfdwafgyl58wikhzsphf URL
    http://beta.quicklisp.org/archive/clack/2022-02-20/clack-20220220-git.tgz
    MD5 a74eeeebb582f3b711088254b6e256f5 NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20220220-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie)
    PARASITES NIL) */
