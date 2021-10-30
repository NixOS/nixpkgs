/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "alexandria";
  version = "20210807-git";

  description = "Alexandria is a collection of portable public domain utilities.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/alexandria/2021-08-07/alexandria-20210807-git.tgz";
    sha256 = "0y2x3xapx06v8083ls4pz12s63gv33d6ix05r61m62h4qqm8qk3j";
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    0y2x3xapx06v8083ls4pz12s63gv33d6ix05r61m62h4qqm8qk3j URL
    http://beta.quicklisp.org/archive/alexandria/2021-08-07/alexandria-20210807-git.tgz
    MD5 0193fd1a1d702b4a0fafa19361b1e644 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20210807-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
