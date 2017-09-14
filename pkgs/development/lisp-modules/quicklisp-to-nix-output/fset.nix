args @ { fetchurl, ... }:
rec {
  baseName = ''fset'';
  version = ''20150113-git'';

  description = ''A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html
'';

  deps = [ args."misc-extensions" args."mt19937" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fset/2015-01-13/fset-20150113-git.tgz'';
    sha256 = ''1k9c48jahw8i4zhx6dc96n0jzxjy2ascr2wng9hmm8vjhhqs5sl0'';
  };

  packageName = "fset";

  asdFilesToKeep = ["fset.asd"];
  overrides = x: x;
}
/* (SYSTEM fset DESCRIPTION A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html

    SHA256 1k9c48jahw8i4zhx6dc96n0jzxjy2ascr2wng9hmm8vjhhqs5sl0 URL
    http://beta.quicklisp.org/archive/fset/2015-01-13/fset-20150113-git.tgz MD5
    89f958cc900e712aed0750b336efbe15 NAME fset FILENAME fset DEPS
    ((NAME misc-extensions FILENAME misc-extensions)
     (NAME mt19937 FILENAME mt19937))
    DEPENDENCIES (misc-extensions mt19937) VERSION 20150113-git SIBLINGS NIL
    PARASITES NIL) */
