args @ { fetchurl, ... }:
rec {
  baseName = ''dissect'';
  version = ''20190710-git'';

  description = ''A lib for introspecting the call stack and active restarts.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dissect/2019-07-10/dissect-20190710-git.tgz'';
    sha256 = ''15h653gbi9iybns0ll8rhjr7diwwnq4g9wf51f6d9846nl1v424b'';
  };

  packageName = "dissect";

  asdFilesToKeep = ["dissect.asd"];
  overrides = x: x;
}
/* (SYSTEM dissect DESCRIPTION
    A lib for introspecting the call stack and active restarts. SHA256
    15h653gbi9iybns0ll8rhjr7diwwnq4g9wf51f6d9846nl1v424b URL
    http://beta.quicklisp.org/archive/dissect/2019-07-10/dissect-20190710-git.tgz
    MD5 fb0e90e86fe4c184c08d19c1ef61d4e4 NAME dissect FILENAME dissect DEPS NIL
    DEPENDENCIES NIL VERSION 20190710-git SIBLINGS NIL PARASITES NIL) */
