/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "metabang-bind";
  version = "20200218-git";

  description = "Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/metabang-bind/2020-02-18/metabang-bind-20200218-git.tgz";
    sha256 = "0mfjzfsv8v6i9ahwldfzznl29i42cmh5srmpgq64ar1vp6bdn1hq";
  };

  packageName = "metabang-bind";

  asdFilesToKeep = ["metabang-bind.asd"];
  overrides = x: x;
}
/* (SYSTEM metabang-bind DESCRIPTION
    Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.
    SHA256 0mfjzfsv8v6i9ahwldfzznl29i42cmh5srmpgq64ar1vp6bdn1hq URL
    http://beta.quicklisp.org/archive/metabang-bind/2020-02-18/metabang-bind-20200218-git.tgz
    MD5 25ee72526862a9d794f7b0fc1826029e NAME metabang-bind FILENAME
    metabang-bind DEPS NIL DEPENDENCIES NIL VERSION 20200218-git SIBLINGS
    (metabang-bind-test) PARASITES NIL) */
