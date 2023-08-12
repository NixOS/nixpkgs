/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-indent";
  version = "20210531-git";

  description = "A very simple library to allow indentation hints for SWANK.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-indent/2021-05-31/trivial-indent-20210531-git.tgz";
    sha256 = "1nqkay4kwy365q1qlba07q9x5ng0sxrcii4fpjqcd8nwbx3kbm8b";
  };

  packageName = "trivial-indent";

  asdFilesToKeep = ["trivial-indent.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-indent DESCRIPTION
    A very simple library to allow indentation hints for SWANK. SHA256
    1nqkay4kwy365q1qlba07q9x5ng0sxrcii4fpjqcd8nwbx3kbm8b URL
    http://beta.quicklisp.org/archive/trivial-indent/2021-05-31/trivial-indent-20210531-git.tgz
    MD5 3bb7d208d9d0614121c1f57fcffe65c7 NAME trivial-indent FILENAME
    trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20210531-git SIBLINGS NIL
    PARASITES NIL) */
