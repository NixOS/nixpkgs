/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-emb";
  version = "20190521-git";

  description = "A templating system for Common Lisp";

  deps = [ args."cl-ppcre" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-emb/2019-05-21/cl-emb-20190521-git.tgz";
    sha256 = "1d6bi2mx1kw7an3maxjp4ldrhkwfdb58va9whxblz2xjlbykdv8d";
  };

  packageName = "cl-emb";

  asdFilesToKeep = ["cl-emb.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-emb DESCRIPTION A templating system for Common Lisp SHA256
    1d6bi2mx1kw7an3maxjp4ldrhkwfdb58va9whxblz2xjlbykdv8d URL
    http://beta.quicklisp.org/archive/cl-emb/2019-05-21/cl-emb-20190521-git.tgz
    MD5 b27bbe8de2206ab7c461700b58d4d527 NAME cl-emb FILENAME cl-emb DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)) DEPENDENCIES (cl-ppcre) VERSION
    20190521-git SIBLINGS NIL PARASITES NIL) */
