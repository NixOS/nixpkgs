/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "metatilities-base";
  version = "20191227-git";

  description = "These are metabang.com's Common Lisp basic utilities.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/metatilities-base/2019-12-27/metatilities-base-20191227-git.tgz";
    sha256 = "1mal51p7mknya2ljcwl3wdjvnirw5vvzic6qcnci7qhmfrb1awil";
  };

  packageName = "metatilities-base";

  asdFilesToKeep = ["metatilities-base.asd"];
  overrides = x: x;
}
/* (SYSTEM metatilities-base DESCRIPTION
    These are metabang.com's Common Lisp basic utilities. SHA256
    1mal51p7mknya2ljcwl3wdjvnirw5vvzic6qcnci7qhmfrb1awil URL
    http://beta.quicklisp.org/archive/metatilities-base/2019-12-27/metatilities-base-20191227-git.tgz
    MD5 7968829ca353c4a42784a151317029f1 NAME metatilities-base FILENAME
    metatilities-base DEPS NIL DEPENDENCIES NIL VERSION 20191227-git SIBLINGS
    (metatilities-base-test) PARASITES NIL) */
