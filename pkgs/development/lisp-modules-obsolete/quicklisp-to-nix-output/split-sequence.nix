/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "split-sequence";
  version = "v2.0.1";

  parasites = [ "split-sequence/tests" ];

  description = "Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/split-sequence/2021-05-31/split-sequence-v2.0.1.tgz";
    sha256 = "0x6jdpx5nwby0mjhavqzbfr97725jaryvawjj2f5w9z2s4m9ciya";
  };

  packageName = "split-sequence";

  asdFilesToKeep = ["split-sequence.asd"];
  overrides = x: x;
}
/* (SYSTEM split-sequence DESCRIPTION
    Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.
    SHA256 0x6jdpx5nwby0mjhavqzbfr97725jaryvawjj2f5w9z2s4m9ciya URL
    http://beta.quicklisp.org/archive/split-sequence/2021-05-31/split-sequence-v2.0.1.tgz
    MD5 871be321b4dbca0a1f958927e9173795 NAME split-sequence FILENAME
    split-sequence DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam)
    VERSION v2.0.1 SIBLINGS NIL PARASITES (split-sequence/tests)) */
