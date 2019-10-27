args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-cltl2'';
  version = ''20190710-git'';

  description = ''Compatibility package exporting CLtL2 functionality'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-cltl2/2019-07-10/trivial-cltl2-20190710-git.tgz'';
    sha256 = ''1qaxwgws8ji6dyh30ff608zpdrplifgkhfdhfnn0367d3rvy11jb'';
  };

  packageName = "trivial-cltl2";

  asdFilesToKeep = ["trivial-cltl2.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-cltl2 DESCRIPTION
    Compatibility package exporting CLtL2 functionality SHA256
    1qaxwgws8ji6dyh30ff608zpdrplifgkhfdhfnn0367d3rvy11jb URL
    http://beta.quicklisp.org/archive/trivial-cltl2/2019-07-10/trivial-cltl2-20190710-git.tgz
    MD5 8114f96b9770a9f0e0a94933918dc171 NAME trivial-cltl2 FILENAME
    trivial-cltl2 DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS NIL
    PARASITES NIL) */
