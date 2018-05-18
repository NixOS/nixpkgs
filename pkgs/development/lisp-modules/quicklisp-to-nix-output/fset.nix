args @ { fetchurl, ... }:
rec {
  baseName = ''fset'';
  version = ''20171019-git'';

  description = ''A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html
'';

  deps = [ args."misc-extensions" args."mt19937" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fset/2017-10-19/fset-20171019-git.tgz'';
    sha256 = ''07qxbj40kmjknmvvb47prj81mpi6j39150iw57hlrzdhlndvilwg'';
  };

  packageName = "fset";

  asdFilesToKeep = ["fset.asd"];
  overrides = x: x;
}
/* (SYSTEM fset DESCRIPTION A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html

    SHA256 07qxbj40kmjknmvvb47prj81mpi6j39150iw57hlrzdhlndvilwg URL
    http://beta.quicklisp.org/archive/fset/2017-10-19/fset-20171019-git.tgz MD5
    dc8de5917c513302dd0e135e6c133978 NAME fset FILENAME fset DEPS
    ((NAME misc-extensions FILENAME misc-extensions)
     (NAME mt19937 FILENAME mt19937))
    DEPENDENCIES (misc-extensions mt19937) VERSION 20171019-git SIBLINGS NIL
    PARASITES NIL) */
