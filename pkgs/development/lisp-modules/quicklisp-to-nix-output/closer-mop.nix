args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20180430-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2018-04-30/closer-mop-20180430-git.tgz'';
    sha256 = ''1bbvjkqjw17dgzy6spqqpdlarcxd0rchki769r43g5p5sghxlb6v'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 1bbvjkqjw17dgzy6spqqpdlarcxd0rchki769r43g5p5sghxlb6v URL
    http://beta.quicklisp.org/archive/closer-mop/2018-04-30/closer-mop-20180430-git.tgz
    MD5 7578c66d4d468a21de9c5cf065b8615f NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20180430-git SIBLINGS NIL PARASITES NIL) */
