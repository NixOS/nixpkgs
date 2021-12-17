/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "vas-string-metrics";
  version = "20160208-git";

  description = "Jaro-Winkler and Levenshtein string distance algorithms.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/vas-string-metrics/2016-02-08/vas-string-metrics-20160208-git.tgz";
    sha256 = "1s9a9bgc2ibknjr6mlbr4gsxcwpjivz5hbl1wz57fsh4n0w8h7ch";
  };

  packageName = "vas-string-metrics";

  asdFilesToKeep = ["vas-string-metrics.asd"];
  overrides = x: x;
}
/* (SYSTEM vas-string-metrics DESCRIPTION
    Jaro-Winkler and Levenshtein string distance algorithms. SHA256
    1s9a9bgc2ibknjr6mlbr4gsxcwpjivz5hbl1wz57fsh4n0w8h7ch URL
    http://beta.quicklisp.org/archive/vas-string-metrics/2016-02-08/vas-string-metrics-20160208-git.tgz
    MD5 5f38d4ee241c11286be6147f481e7fd0 NAME vas-string-metrics FILENAME
    vas-string-metrics DEPS NIL DEPENDENCIES NIL VERSION 20160208-git SIBLINGS
    (test.vas-string-metrics) PARASITES NIL) */
