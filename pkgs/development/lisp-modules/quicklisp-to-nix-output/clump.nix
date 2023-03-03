/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clump";
  version = "20160825-git";

  description = "Library for operations on different kinds of trees";

  deps = [ args."acclimation" args."clump-2-3-tree" args."clump-binary-tree" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clump/2016-08-25/clump-20160825-git.tgz";
    sha256 = "1mngxmwklpi52inihkp4akzdi7y32609spfi70yamwgzc1wijbrl";
  };

  packageName = "clump";

  asdFilesToKeep = ["clump.asd"];
  overrides = x: x;
}
/* (SYSTEM clump DESCRIPTION Library for operations on different kinds of trees
    SHA256 1mngxmwklpi52inihkp4akzdi7y32609spfi70yamwgzc1wijbrl URL
    http://beta.quicklisp.org/archive/clump/2016-08-25/clump-20160825-git.tgz
    MD5 5132d2800138d435ef69f7e68b025c8f NAME clump FILENAME clump DEPS
    ((NAME acclimation FILENAME acclimation)
     (NAME clump-2-3-tree FILENAME clump-2-3-tree)
     (NAME clump-binary-tree FILENAME clump-binary-tree))
    DEPENDENCIES (acclimation clump-2-3-tree clump-binary-tree) VERSION
    20160825-git SIBLINGS (clump-2-3-tree clump-binary-tree clump-test)
    PARASITES NIL) */
