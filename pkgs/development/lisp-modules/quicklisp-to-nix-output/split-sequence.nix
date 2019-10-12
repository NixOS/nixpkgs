args @ { fetchurl, ... }:
{
  baseName = ''split-sequence'';
  version = ''v2.0.0'';

  parasites = [ "split-sequence/tests" ];

  description = ''Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.'';

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/split-sequence/2019-05-21/split-sequence-v2.0.0.tgz'';
    sha256 = ''09cmmswzl1kahvlzgqv8lqm9qcnz5iqg8f26fw3mm9rb3dcp7aba'';
  };

  packageName = "split-sequence";

  asdFilesToKeep = ["split-sequence.asd"];
  overrides = x: x;
}
/* (SYSTEM split-sequence DESCRIPTION
    Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.
    SHA256 09cmmswzl1kahvlzgqv8lqm9qcnz5iqg8f26fw3mm9rb3dcp7aba URL
    http://beta.quicklisp.org/archive/split-sequence/2019-05-21/split-sequence-v2.0.0.tgz
    MD5 88aadc6c9da23663ebbb39d546991df4 NAME split-sequence FILENAME
    split-sequence DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam)
    VERSION v2.0.0 SIBLINGS NIL PARASITES (split-sequence/tests)) */
