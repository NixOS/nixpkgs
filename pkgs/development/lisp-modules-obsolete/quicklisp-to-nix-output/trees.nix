/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trees";
  version = "20180131-git";

  parasites = [ "trees-tests" ];

  description = "A library for binary trees in normal and balanced flavors";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trees/2018-01-31/trees-20180131-git.tgz";
    sha256 = "1p54j2kav1vggdjw5msdpmfyi7cxh41f4j669rgp0g8fpimmzcfg";
  };

  packageName = "trees";

  asdFilesToKeep = ["trees.asd"];
  overrides = x: x;
}
/* (SYSTEM trees DESCRIPTION
    A library for binary trees in normal and balanced flavors SHA256
    1p54j2kav1vggdjw5msdpmfyi7cxh41f4j669rgp0g8fpimmzcfg URL
    http://beta.quicklisp.org/archive/trees/2018-01-31/trees-20180131-git.tgz
    MD5 a1b156d15d444d114f475f7abc908064 NAME trees FILENAME trees DEPS NIL
    DEPENDENCIES NIL VERSION 20180131-git SIBLINGS NIL PARASITES (trees-tests)) */
