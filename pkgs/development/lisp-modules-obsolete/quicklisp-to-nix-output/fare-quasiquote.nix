/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fare-quasiquote";
  version = "20200925-git";

  description = "Portable, matchable implementation of quasiquote";

  deps = [ args."fare-utils" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fare-quasiquote/2020-09-25/fare-quasiquote-20200925-git.tgz";
    sha256 = "0k25kx4gvr046bcnv5mqxbb4483v9p2lk7dvzjkgj2cxrvczmj8b";
  };

  packageName = "fare-quasiquote";

  asdFilesToKeep = ["fare-quasiquote.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-quasiquote DESCRIPTION
    Portable, matchable implementation of quasiquote SHA256
    0k25kx4gvr046bcnv5mqxbb4483v9p2lk7dvzjkgj2cxrvczmj8b URL
    http://beta.quicklisp.org/archive/fare-quasiquote/2020-09-25/fare-quasiquote-20200925-git.tgz
    MD5 7af0a97c445d88acacecfc851496adb3 NAME fare-quasiquote FILENAME
    fare-quasiquote DEPS ((NAME fare-utils FILENAME fare-utils)) DEPENDENCIES
    (fare-utils) VERSION 20200925-git SIBLINGS
    (fare-quasiquote-extras fare-quasiquote-optima fare-quasiquote-readtable)
    PARASITES NIL) */
