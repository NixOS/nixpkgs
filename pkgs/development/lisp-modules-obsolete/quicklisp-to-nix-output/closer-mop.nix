/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "closer-mop";
  version = "20211209-git";

  description = "Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/closer-mop/2021-12-09/closer-mop-20211209-git.tgz";
    sha256 = "1zrjsibbph8dz8k0qjawp9c22094rag3aasd4r761m2r482xf5zl";
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 1zrjsibbph8dz8k0qjawp9c22094rag3aasd4r761m2r482xf5zl URL
    http://beta.quicklisp.org/archive/closer-mop/2021-12-09/closer-mop-20211209-git.tgz
    MD5 0b2a02f6b6a57b5b707df5e1d51950cd NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20211209-git SIBLINGS NIL PARASITES NIL) */
