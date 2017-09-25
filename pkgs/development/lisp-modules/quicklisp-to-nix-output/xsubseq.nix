args @ { fetchurl, ... }:
rec {
  baseName = ''xsubseq'';
  version = ''20150113-git'';

  description = ''Efficient way to manage "subseq"s in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xsubseq/2015-01-13/xsubseq-20150113-git.tgz'';
    sha256 = ''0ykjhi7pkqcwm00yzhqvngnx07hsvwbj0c72b08rj4dkngg8is5q'';
  };

  packageName = "xsubseq";

  asdFilesToKeep = ["xsubseq.asd"];
  overrides = x: x;
}
/* (SYSTEM xsubseq DESCRIPTION Efficient way to manage "subseq"s in Common Lisp
    SHA256 0ykjhi7pkqcwm00yzhqvngnx07hsvwbj0c72b08rj4dkngg8is5q URL
    http://beta.quicklisp.org/archive/xsubseq/2015-01-13/xsubseq-20150113-git.tgz
    MD5 56f7a4ac1f05f10e7226e0e5b7b0bfa7 NAME xsubseq FILENAME xsubseq DEPS NIL
    DEPENDENCIES NIL VERSION 20150113-git SIBLINGS (xsubseq-test) PARASITES NIL) */
