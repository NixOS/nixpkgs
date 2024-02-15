/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "binomial-heap";
  version = "20130420-git";

  description = "A compact binomial heap implementation.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/binomial-heap/2013-04-20/binomial-heap-20130420-git.tgz";
    sha256 = "0fl062psd0jn94raip46lq342xmsq0xgrql6v5f9j9w0ps0dg2ap";
  };

  packageName = "binomial-heap";

  asdFilesToKeep = ["binomial-heap.asd"];
  overrides = x: x;
}
/* (SYSTEM binomial-heap DESCRIPTION A compact binomial heap implementation.
    SHA256 0fl062psd0jn94raip46lq342xmsq0xgrql6v5f9j9w0ps0dg2ap URL
    http://beta.quicklisp.org/archive/binomial-heap/2013-04-20/binomial-heap-20130420-git.tgz
    MD5 ca40cb01b88a3fe902cc4cc25fb2d242 NAME binomial-heap FILENAME
    binomial-heap DEPS NIL DEPENDENCIES NIL VERSION 20130420-git SIBLINGS NIL
    PARASITES NIL) */
