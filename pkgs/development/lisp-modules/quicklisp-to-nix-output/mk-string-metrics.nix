/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mk-string-metrics";
  version = "20180131-git";

  description = "efficient implementations of various string metric algorithms";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mk-string-metrics/2018-01-31/mk-string-metrics-20180131-git.tgz";
    sha256 = "10xb9n6568nh019nq3phijbc7l6hkv69yllfiqvc1zzsprxpkwc4";
  };

  packageName = "mk-string-metrics";

  asdFilesToKeep = ["mk-string-metrics.asd"];
  overrides = x: x;
}
/* (SYSTEM mk-string-metrics DESCRIPTION
    efficient implementations of various string metric algorithms SHA256
    10xb9n6568nh019nq3phijbc7l6hkv69yllfiqvc1zzsprxpkwc4 URL
    http://beta.quicklisp.org/archive/mk-string-metrics/2018-01-31/mk-string-metrics-20180131-git.tgz
    MD5 40f23794a7d841cb178f5951d3992886 NAME mk-string-metrics FILENAME
    mk-string-metrics DEPS NIL DEPENDENCIES NIL VERSION 20180131-git SIBLINGS
    (mk-string-metrics-tests) PARASITES NIL) */
