args @ { fetchurl, ... }:
rec {
  baseName = ''marshal'';
  version = ''cl-20201016-git'';

  description = ''marshal: Simple (de)serialization of Lisp datastructures.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-marshal/2020-10-16/cl-marshal-20201016-git.tgz'';
    sha256 = ''03j52yhgpc2myypgy07213l20rznxvf6m3sfbzy2wyapcmv7nxnz'';
  };

  packageName = "marshal";

  asdFilesToKeep = ["marshal.asd"];
  overrides = x: x;
}
/* (SYSTEM marshal DESCRIPTION
    marshal: Simple (de)serialization of Lisp datastructures. SHA256
    03j52yhgpc2myypgy07213l20rznxvf6m3sfbzy2wyapcmv7nxnz URL
    http://beta.quicklisp.org/archive/cl-marshal/2020-10-16/cl-marshal-20201016-git.tgz
    MD5 243a2c3a5f1243ffb1639bca32a0aff0 NAME marshal FILENAME marshal DEPS NIL
    DEPENDENCIES NIL VERSION cl-20201016-git SIBLINGS (marshal-tests) PARASITES
    NIL) */
