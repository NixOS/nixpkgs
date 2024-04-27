/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-css";
  version = "20140914-git";

  description = "Simple inline CSS generator";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-css/2014-09-14/cl-css-20140914-git.tgz";
    sha256 = "16zjm10qqyv5v0ysvicbiscplrwlfr0assbf01gp73j1m108rn7n";
  };

  packageName = "cl-css";

  asdFilesToKeep = ["cl-css.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-css DESCRIPTION Simple inline CSS generator SHA256
    16zjm10qqyv5v0ysvicbiscplrwlfr0assbf01gp73j1m108rn7n URL
    http://beta.quicklisp.org/archive/cl-css/2014-09-14/cl-css-20140914-git.tgz
    MD5 a91f5a5d6a751af31d5c4fd8170f6ece NAME cl-css FILENAME cl-css DEPS NIL
    DEPENDENCIES NIL VERSION 20140914-git SIBLINGS NIL PARASITES NIL) */
