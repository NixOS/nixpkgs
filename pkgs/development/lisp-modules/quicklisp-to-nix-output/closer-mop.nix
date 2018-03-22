args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20180131-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2018-01-31/closer-mop-20180131-git.tgz'';
    sha256 = ''0lsfpxppbd8j4ayfrhd723ck367yb4amdywwaqj9yivh00zn4r6s'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 0lsfpxppbd8j4ayfrhd723ck367yb4amdywwaqj9yivh00zn4r6s URL
    http://beta.quicklisp.org/archive/closer-mop/2018-01-31/closer-mop-20180131-git.tgz
    MD5 d572109e102869d89f206a46619c2ed0 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20180131-git SIBLINGS NIL PARASITES NIL) */
