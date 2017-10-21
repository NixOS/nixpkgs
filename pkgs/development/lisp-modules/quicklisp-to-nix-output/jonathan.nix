args @ { fetchurl, ... }:
rec {
  baseName = ''jonathan'';
  version = ''20170630-git'';

  description = ''High performance JSON encoder and decoder. Currently support: SBCL, CCL.'';

  deps = [ args."babel" args."cl-annot" args."cl-ppcre" args."cl-syntax" args."cl-syntax-annot" args."fast-io" args."proc-parse" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/jonathan/2017-06-30/jonathan-20170630-git.tgz'';
    sha256 = ''0vxnxs38f6gxw51b69n09p2qmph17jkhwdvwq02sayiq3p4w10bm'';
  };

  packageName = "jonathan";

  asdFilesToKeep = ["jonathan.asd"];
  overrides = x: x;
}
/* (SYSTEM jonathan DESCRIPTION
    High performance JSON encoder and decoder. Currently support: SBCL, CCL.
    SHA256 0vxnxs38f6gxw51b69n09p2qmph17jkhwdvwq02sayiq3p4w10bm URL
    http://beta.quicklisp.org/archive/jonathan/2017-06-30/jonathan-20170630-git.tgz
    MD5 5d82723835164f4e3d9c4d031322eb98 NAME jonathan FILENAME jonathan DEPS
    ((NAME babel FILENAME babel) (NAME cl-annot FILENAME cl-annot)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME fast-io FILENAME fast-io) (NAME proc-parse FILENAME proc-parse)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (babel cl-annot cl-ppcre cl-syntax cl-syntax-annot fast-io proc-parse
     trivial-types)
    VERSION 20170630-git SIBLINGS (jonathan-test) PARASITES NIL) */
