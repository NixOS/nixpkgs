/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clx";
  version = "20211020-git";

  parasites = [ "clx/test" ];

  description = "An implementation of the X Window System protocol in Lisp.";

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clx/2021-10-20/clx-20211020-git.tgz";
    sha256 = "1mgqcqakbm8s4w2r9831xzhy9lyifcl2b3rhl5p76s5vpnjmp88k";
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    1mgqcqakbm8s4w2r9831xzhy9lyifcl2b3rhl5p76s5vpnjmp88k URL
    http://beta.quicklisp.org/archive/clx/2021-10-20/clx-20211020-git.tgz MD5
    ac10db96a6426cf462f8d417a7797621 NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20211020-git
    SIBLINGS NIL PARASITES (clx/test)) */
