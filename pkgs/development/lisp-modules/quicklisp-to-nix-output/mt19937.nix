/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mt19937";
  version = "1.1.1";

  description = "Portable MT19937 Mersenne Twister random number generator";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mt19937/2011-02-19/mt19937-1.1.1.tgz";
    sha256 = "1iw636b0iw5ygkv02y8i41lh7xj0acglv0hg5agryn0zzi2nf1xv";
  };

  packageName = "mt19937";

  asdFilesToKeep = ["mt19937.asd"];
  overrides = x: x;
}
/* (SYSTEM mt19937 DESCRIPTION
    Portable MT19937 Mersenne Twister random number generator SHA256
    1iw636b0iw5ygkv02y8i41lh7xj0acglv0hg5agryn0zzi2nf1xv URL
    http://beta.quicklisp.org/archive/mt19937/2011-02-19/mt19937-1.1.1.tgz MD5
    54c63977b6d77abd66ebe0227b77c143 NAME mt19937 FILENAME mt19937 DEPS NIL
    DEPENDENCIES NIL VERSION 1.1.1 SIBLINGS NIL PARASITES NIL) */
