/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-annot";
  version = "20150608-git";

  description = "Python-like Annotation Syntax for Common Lisp";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-annot/2015-06-08/cl-annot-20150608-git.tgz";
    sha256 = "0ixsp20rk498phv3iivipn3qbw7a7x260x63hc6kpv2s746lpdg3";
  };

  packageName = "cl-annot";

  asdFilesToKeep = ["cl-annot.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-annot DESCRIPTION Python-like Annotation Syntax for Common Lisp
    SHA256 0ixsp20rk498phv3iivipn3qbw7a7x260x63hc6kpv2s746lpdg3 URL
    http://beta.quicklisp.org/archive/cl-annot/2015-06-08/cl-annot-20150608-git.tgz
    MD5 35d8f79311bda4dd86002d11edcd0a21 NAME cl-annot FILENAME cl-annot DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20150608-git SIBLINGS NIL PARASITES NIL) */
