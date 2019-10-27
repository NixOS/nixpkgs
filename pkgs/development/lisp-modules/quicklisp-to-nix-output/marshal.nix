args @ { fetchurl, ... }:
rec {
  baseName = ''marshal'';
  version = ''cl-20180328-git'';

  description = ''marshal: Simple (de)serialization of Lisp datastructures.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-marshal/2018-03-28/cl-marshal-20180328-git.tgz'';
    sha256 = ''09qmrq9lv9jlb2cnac80qd9b20swy598sfkhvngs3vcjl5xmmdhd'';
  };

  packageName = "marshal";

  asdFilesToKeep = ["marshal.asd"];
  overrides = x: x;
}
/* (SYSTEM marshal DESCRIPTION
    marshal: Simple (de)serialization of Lisp datastructures. SHA256
    09qmrq9lv9jlb2cnac80qd9b20swy598sfkhvngs3vcjl5xmmdhd URL
    http://beta.quicklisp.org/archive/cl-marshal/2018-03-28/cl-marshal-20180328-git.tgz
    MD5 2d13dd2a276f1e63965498d10d9406ce NAME marshal FILENAME marshal DEPS NIL
    DEPENDENCIES NIL VERSION cl-20180328-git SIBLINGS (marshal-tests) PARASITES
    NIL) */
