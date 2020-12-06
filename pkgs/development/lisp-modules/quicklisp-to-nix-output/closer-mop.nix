args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20201016-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2020-10-16/closer-mop-20201016-git.tgz'';
    sha256 = ''1fccvxzrrfdiwjx9cdia7idp8xym1y86bf7zcyxvmpkdcvgdsdcd'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 1fccvxzrrfdiwjx9cdia7idp8xym1y86bf7zcyxvmpkdcvgdsdcd URL
    http://beta.quicklisp.org/archive/closer-mop/2020-10-16/closer-mop-20201016-git.tgz
    MD5 aca5b5432a782075906efd5aa948b748 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20201016-git SIBLINGS NIL PARASITES NIL) */
