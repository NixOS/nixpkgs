/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "closer-mop";
  version = "20210807-git";

  description = "Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/closer-mop/2021-08-07/closer-mop-20210807-git.tgz";
    sha256 = "1b3h6fw4wh11brmvi9p0j50zynbp7bgbhshcbngmd0ffdpinkh15";
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 1b3h6fw4wh11brmvi9p0j50zynbp7bgbhshcbngmd0ffdpinkh15 URL
    http://beta.quicklisp.org/archive/closer-mop/2021-08-07/closer-mop-20210807-git.tgz
    MD5 02b29c503d823ca9701b231c23bbd3cd NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20210807-git SIBLINGS NIL PARASITES NIL) */
