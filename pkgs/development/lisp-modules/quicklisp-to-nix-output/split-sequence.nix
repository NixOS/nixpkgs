args @ { fetchurl, ... }:
rec {
  baseName = ''split-sequence'';
  version = ''v1.4.1'';

  parasites = [ "split-sequence/tests" ];

  description = ''Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.'';

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/split-sequence/2018-02-28/split-sequence-v1.4.1.tgz'';
    sha256 = ''04ag6cdllqhc45psjp7bcwkhnqdhpidi8grn15c7pnaf86apgq3q'';
  };

  packageName = "split-sequence";

  asdFilesToKeep = ["split-sequence.asd"];
  overrides = x: x;
}
/* (SYSTEM split-sequence DESCRIPTION
    Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.
    SHA256 04ag6cdllqhc45psjp7bcwkhnqdhpidi8grn15c7pnaf86apgq3q URL
    http://beta.quicklisp.org/archive/split-sequence/2018-02-28/split-sequence-v1.4.1.tgz
    MD5 b85e3ef2bc2cb2ce8a2c101759539ba7 NAME split-sequence FILENAME
    split-sequence DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam)
    VERSION v1.4.1 SIBLINGS NIL PARASITES (split-sequence/tests)) */
