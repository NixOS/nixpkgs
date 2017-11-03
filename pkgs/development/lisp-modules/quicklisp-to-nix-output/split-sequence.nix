args @ { fetchurl, ... }:
rec {
  baseName = ''split-sequence'';
  version = ''1.2'';

  parasites = [ "split-sequence-tests" ];

  description = ''Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.'';

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz'';
    sha256 = ''12x5yfvinqz9jzxwlsg226103a9sdf67zpzn5izggvdlw0v5qp0l'';
  };

  packageName = "split-sequence";

  asdFilesToKeep = ["split-sequence.asd"];
  overrides = x: x;
}
/* (SYSTEM split-sequence DESCRIPTION
    Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.
    SHA256 12x5yfvinqz9jzxwlsg226103a9sdf67zpzn5izggvdlw0v5qp0l URL
    http://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz
    MD5 194e24d60f0fba70a059633960052e21 NAME split-sequence FILENAME
    split-sequence DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam)
    VERSION 1.2 SIBLINGS NIL PARASITES (split-sequence-tests)) */
