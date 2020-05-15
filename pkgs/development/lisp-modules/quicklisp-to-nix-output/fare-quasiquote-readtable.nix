args @ { fetchurl, ... }:
rec {
  baseName = ''fare-quasiquote-readtable'';
  version = ''fare-quasiquote-20190521-git'';

  description = ''Using fare-quasiquote with named-readtable'';

  deps = [ args."fare-quasiquote" args."fare-utils" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz'';
    sha256 = ''1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj'';
  };

  packageName = "fare-quasiquote-readtable";

  asdFilesToKeep = ["fare-quasiquote-readtable.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-quasiquote-readtable DESCRIPTION
    Using fare-quasiquote with named-readtable SHA256
    1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj URL
    http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz
    MD5 e08c24d35a485a74642bd0c7c06662d6 NAME fare-quasiquote-readtable
    FILENAME fare-quasiquote-readtable DEPS
    ((NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-utils FILENAME fare-utils)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (fare-quasiquote fare-utils named-readtables) VERSION
    fare-quasiquote-20190521-git SIBLINGS
    (fare-quasiquote-extras fare-quasiquote-optima fare-quasiquote-test
     fare-quasiquote)
    PARASITES NIL) */
