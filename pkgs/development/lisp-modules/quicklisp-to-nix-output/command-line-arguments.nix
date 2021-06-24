/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "command-line-arguments";
  version = "20200325-git";

  description = "small library to deal with command-line arguments";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/command-line-arguments/2020-03-25/command-line-arguments-20200325-git.tgz";
    sha256 = "0ny0c0aw3mfjpmf31pnd9zfnylqh8ji2yi636w1f352c13z2w5sz";
  };

  packageName = "command-line-arguments";

  asdFilesToKeep = ["command-line-arguments.asd"];
  overrides = x: x;
}
/* (SYSTEM command-line-arguments DESCRIPTION
    small library to deal with command-line arguments SHA256
    0ny0c0aw3mfjpmf31pnd9zfnylqh8ji2yi636w1f352c13z2w5sz URL
    http://beta.quicklisp.org/archive/command-line-arguments/2020-03-25/command-line-arguments-20200325-git.tgz
    MD5 5a860667bc3feef212028b90c9e026f8 NAME command-line-arguments FILENAME
    command-line-arguments DEPS NIL DEPENDENCIES NIL VERSION 20200325-git
    SIBLINGS NIL PARASITES NIL) */
