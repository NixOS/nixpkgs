args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20191227-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2019-12-27/closer-mop-20191227-git.tgz'';
    sha256 = ''12qkaadpbj946ln17xp5cjahd9jkbwv9j51rvk3q9kqmsm0r1r9l'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 12qkaadpbj946ln17xp5cjahd9jkbwv9j51rvk3q9kqmsm0r1r9l URL
    http://beta.quicklisp.org/archive/closer-mop/2019-12-27/closer-mop-20191227-git.tgz
    MD5 67dda2ff56690bb8eec6131983605031 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20191227-git SIBLINGS NIL PARASITES NIL) */
