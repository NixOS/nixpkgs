/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clump-binary-tree";
  version = "clump-20160825-git";

  description = "System lacks description";

  deps = [ args."acclimation" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clump/2016-08-25/clump-20160825-git.tgz";
    sha256 = "1mngxmwklpi52inihkp4akzdi7y32609spfi70yamwgzc1wijbrl";
  };

  packageName = "clump-binary-tree";

  asdFilesToKeep = ["clump-binary-tree.asd"];
  overrides = x: x;
}
/* (SYSTEM clump-binary-tree DESCRIPTION System lacks description SHA256
    1mngxmwklpi52inihkp4akzdi7y32609spfi70yamwgzc1wijbrl URL
    http://beta.quicklisp.org/archive/clump/2016-08-25/clump-20160825-git.tgz
    MD5 5132d2800138d435ef69f7e68b025c8f NAME clump-binary-tree FILENAME
    clump-binary-tree DEPS ((NAME acclimation FILENAME acclimation))
    DEPENDENCIES (acclimation) VERSION clump-20160825-git SIBLINGS
    (clump-2-3-tree clump-test clump) PARASITES NIL) */
