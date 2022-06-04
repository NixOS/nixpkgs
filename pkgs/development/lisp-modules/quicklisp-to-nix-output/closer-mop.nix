/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "closer-mop";
  version = "20220220-git";

  description = "Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/closer-mop/2022-02-20/closer-mop-20220220-git.tgz";
    sha256 = "090scah4xj4ca9h8n9mblzkv6452qjby0x5ss9prhixpi3j47wx1";
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 090scah4xj4ca9h8n9mblzkv6452qjby0x5ss9prhixpi3j47wx1 URL
    http://beta.quicklisp.org/archive/closer-mop/2022-02-20/closer-mop-20220220-git.tgz
    MD5 51cf41fa1369e7a969d0e6ea05b38355 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20220220-git SIBLINGS NIL PARASITES NIL) */
