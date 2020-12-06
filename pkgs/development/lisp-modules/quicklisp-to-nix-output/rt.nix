args @ { fetchurl, ... }:
rec {
  baseName = ''rt'';
  version = ''20101006-git'';

  description = ''MIT Regression Tester'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/rt/2010-10-06/rt-20101006-git.tgz'';
    sha256 = ''1jncar0xwkqk8yrc2dln389ivvgzs7ijdhhs3zpfyi5d21f0qa1v'';
  };

  packageName = "rt";

  asdFilesToKeep = ["rt.asd"];
  overrides = x: x;
}
/* (SYSTEM rt DESCRIPTION MIT Regression Tester SHA256
    1jncar0xwkqk8yrc2dln389ivvgzs7ijdhhs3zpfyi5d21f0qa1v URL
    http://beta.quicklisp.org/archive/rt/2010-10-06/rt-20101006-git.tgz MD5
    94a56c473399572ca835ac91c77c04e5 NAME rt FILENAME rt DEPS NIL DEPENDENCIES
    NIL VERSION 20101006-git SIBLINGS NIL PARASITES NIL) */
