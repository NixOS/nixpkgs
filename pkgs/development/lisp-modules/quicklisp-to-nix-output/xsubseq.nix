args @ { fetchurl, ... }:
rec {
  baseName = ''xsubseq'';
  version = ''20170830-git'';

  description = ''Efficient way to manage "subseq"s in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xsubseq/2017-08-30/xsubseq-20170830-git.tgz'';
    sha256 = ''1am63wkha97hyvkqf4ydx3q07mqpa0chkx65znr7kmqi83a8waml'';
  };

  packageName = "xsubseq";

  asdFilesToKeep = ["xsubseq.asd"];
  overrides = x: x;
}
/* (SYSTEM xsubseq DESCRIPTION Efficient way to manage "subseq"s in Common Lisp
    SHA256 1am63wkha97hyvkqf4ydx3q07mqpa0chkx65znr7kmqi83a8waml URL
    http://beta.quicklisp.org/archive/xsubseq/2017-08-30/xsubseq-20170830-git.tgz
    MD5 960bb8f329649b6e4b820e065e6b38e8 NAME xsubseq FILENAME xsubseq DEPS NIL
    DEPENDENCIES NIL VERSION 20170830-git SIBLINGS (xsubseq-test) PARASITES NIL) */
