/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "vas-string-metrics";
  version = "20211209-git";

  description = "Jaro-Winkler and Levenshtein string distance algorithms.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/vas-string-metrics/2021-12-09/vas-string-metrics-20211209-git.tgz";
    sha256 = "0q8zzfmwprjw6wmj8aifizx06xw9yrq0c8qhwhrak62cyz9lvf8n";
  };

  packageName = "vas-string-metrics";

  asdFilesToKeep = ["vas-string-metrics.asd"];
  overrides = x: x;
}
/* (SYSTEM vas-string-metrics DESCRIPTION
    Jaro-Winkler and Levenshtein string distance algorithms. SHA256
    0q8zzfmwprjw6wmj8aifizx06xw9yrq0c8qhwhrak62cyz9lvf8n URL
    http://beta.quicklisp.org/archive/vas-string-metrics/2021-12-09/vas-string-metrics-20211209-git.tgz
    MD5 b1264bac0f9516d9617397e1b7a7c20e NAME vas-string-metrics FILENAME
    vas-string-metrics DEPS NIL DEPENDENCIES NIL VERSION 20211209-git SIBLINGS
    (test.vas-string-metrics) PARASITES NIL) */
