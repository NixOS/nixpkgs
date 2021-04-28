/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "closer-mop";
  version = "20210228-git";

  description = "Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/closer-mop/2021-02-28/closer-mop-20210228-git.tgz";
    sha256 = "0x3rp2v84zzw5mhcxrgbq2kcb9gs4jn1l9rh4ylsnih89l9lqc6i";
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 0x3rp2v84zzw5mhcxrgbq2kcb9gs4jn1l9rh4ylsnih89l9lqc6i URL
    http://beta.quicklisp.org/archive/closer-mop/2021-02-28/closer-mop-20210228-git.tgz
    MD5 49c0004ff21157bc99f227cecf7b6025 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20210228-git SIBLINGS NIL PARASITES NIL) */
