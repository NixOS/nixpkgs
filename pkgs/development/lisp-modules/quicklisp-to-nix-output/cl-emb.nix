args @ { fetchurl, ... }:
rec {
  baseName = ''cl-emb'';
  version = ''20180228-git'';

  description = ''A templating system for Common Lisp'';

  deps = [ args."cl-ppcre" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-emb/2018-02-28/cl-emb-20180228-git.tgz'';
    sha256 = ''0b7y3n65sjn3xk03jflw363m6jkx86zf9v540d4n5jv4vcn34sqw'';
  };

  packageName = "cl-emb";

  asdFilesToKeep = ["cl-emb.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-emb DESCRIPTION A templating system for Common Lisp SHA256
    0b7y3n65sjn3xk03jflw363m6jkx86zf9v540d4n5jv4vcn34sqw URL
    http://beta.quicklisp.org/archive/cl-emb/2018-02-28/cl-emb-20180228-git.tgz
    MD5 94db80b2a91611e71ada33f500b49d22 NAME cl-emb FILENAME cl-emb DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)) DEPENDENCIES (cl-ppcre) VERSION
    20180228-git SIBLINGS NIL PARASITES NIL) */
