args @ { fetchurl, ... }:
rec {
  baseName = ''fare-quasiquote'';
  version = ''20190521-git'';

  description = ''Portable, matchable implementation of quasiquote'';

  deps = [ args."fare-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz'';
    sha256 = ''1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj'';
  };

  packageName = "fare-quasiquote";

  asdFilesToKeep = ["fare-quasiquote.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-quasiquote DESCRIPTION
    Portable, matchable implementation of quasiquote SHA256
    1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj URL
    http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz
    MD5 e08c24d35a485a74642bd0c7c06662d6 NAME fare-quasiquote FILENAME
    fare-quasiquote DEPS ((NAME fare-utils FILENAME fare-utils)) DEPENDENCIES
    (fare-utils) VERSION 20190521-git SIBLINGS
    (fare-quasiquote-extras fare-quasiquote-optima fare-quasiquote-readtable
     fare-quasiquote-test)
    PARASITES NIL) */
