args @ { fetchurl, ... }:
rec {
  baseName = ''split-sequence'';
  version = ''v1.5.0'';

  parasites = [ "split-sequence/tests" ];

  description = ''Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.'';

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/split-sequence/2018-10-18/split-sequence-v1.5.0.tgz'';
    sha256 = ''0cxdgprb8c15fydm09aqvc8sdp5n87m6khv70kzkms1n2vm6sb0g'';
  };

  packageName = "split-sequence";

  asdFilesToKeep = ["split-sequence.asd"];
  overrides = x: x;
}
/* (SYSTEM split-sequence DESCRIPTION
    Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.
    SHA256 0cxdgprb8c15fydm09aqvc8sdp5n87m6khv70kzkms1n2vm6sb0g URL
    http://beta.quicklisp.org/archive/split-sequence/2018-10-18/split-sequence-v1.5.0.tgz
    MD5 67844853787187d993e6d530306eb2b4 NAME split-sequence FILENAME
    split-sequence DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam)
    VERSION v1.5.0 SIBLINGS NIL PARASITES (split-sequence/tests)) */
