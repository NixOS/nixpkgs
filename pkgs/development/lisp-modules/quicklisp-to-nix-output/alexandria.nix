/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "alexandria";
  version = "20220220-git";

  parasites = [ "alexandria/tests" ];

  description = "Alexandria is a collection of portable public domain utilities.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/alexandria/2022-02-20/alexandria-20220220-git.tgz";
    sha256 = "1i2hw3v97xy8x4v6bd2md6ydyk1x6lh4hv3lqm5y861v0q182mlj";
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    1i2hw3v97xy8x4v6bd2md6ydyk1x6lh4hv3lqm5y861v0q182mlj URL
    http://beta.quicklisp.org/archive/alexandria/2022-02-20/alexandria-20220220-git.tgz
    MD5 33d42a3f39fa9487215d768a65f6c254 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20220220-git SIBLINGS NIL PARASITES
    (alexandria/tests)) */
