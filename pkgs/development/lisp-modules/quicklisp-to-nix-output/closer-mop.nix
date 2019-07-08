args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20190107-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2019-01-07/closer-mop-20190107-git.tgz'';
    sha256 = ''0h6fd0kr3g8dd782sxd7zrqljqfnw6pz1dsiadl0x853ki680gcw'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 0h6fd0kr3g8dd782sxd7zrqljqfnw6pz1dsiadl0x853ki680gcw URL
    http://beta.quicklisp.org/archive/closer-mop/2019-01-07/closer-mop-20190107-git.tgz
    MD5 6aa5a1e9901b579eb50e2fb46035bc50 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20190107-git SIBLINGS NIL PARASITES NIL) */
