/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "closer-mop";
  version = "20210411-git";

  description = "Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/closer-mop/2021-04-11/closer-mop-20210411-git.tgz";
    sha256 = "0pynql962m2z7wqnmd51a2xm3wsqvgfxcq9maw2br0zs0icys236";
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 0pynql962m2z7wqnmd51a2xm3wsqvgfxcq9maw2br0zs0icys236 URL
    http://beta.quicklisp.org/archive/closer-mop/2021-04-11/closer-mop-20210411-git.tgz
    MD5 05b05d98ad294f8bd6f9779d04cc848a NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20210411-git SIBLINGS NIL PARASITES NIL) */
