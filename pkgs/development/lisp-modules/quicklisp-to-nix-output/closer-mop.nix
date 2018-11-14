args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20180831-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2018-08-31/closer-mop-20180831-git.tgz'';
    sha256 = ''01lzgh6rgbmfyfspiligkq44z56h2xgg55hxixnrgycbaipzgkbg'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 01lzgh6rgbmfyfspiligkq44z56h2xgg55hxixnrgycbaipzgkbg URL
    http://beta.quicklisp.org/archive/closer-mop/2018-08-31/closer-mop-20180831-git.tgz
    MD5 968426b07f9792f95fe3c9b83d68d756 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20180831-git SIBLINGS NIL PARASITES NIL) */
