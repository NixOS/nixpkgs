/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "make-hash";
  version = "20130615-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/make-hash/2013-06-15/make-hash-20130615-git.tgz";
    sha256 = "1ghcyqjhizkbfsvx1cih7d665w8yvbs1xv8pfi3hs1ghbn8njbkw";
  };

  packageName = "make-hash";

  asdFilesToKeep = ["make-hash.asd"];
  overrides = x: x;
}
/* (SYSTEM make-hash DESCRIPTION System lacks description SHA256
    1ghcyqjhizkbfsvx1cih7d665w8yvbs1xv8pfi3hs1ghbn8njbkw URL
    http://beta.quicklisp.org/archive/make-hash/2013-06-15/make-hash-20130615-git.tgz
    MD5 4f612ef068411284c88e0381fa4a0c7f NAME make-hash FILENAME make-hash DEPS
    NIL DEPENDENCIES NIL VERSION 20130615-git SIBLINGS (make-hash-tests)
    PARASITES NIL) */
