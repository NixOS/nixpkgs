/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fare-quasiquote-readtable";
  version = "fare-quasiquote-20200925-git";

  description = "Using fare-quasiquote with named-readtable";

  deps = [ args."fare-quasiquote" args."fare-utils" args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fare-quasiquote/2020-09-25/fare-quasiquote-20200925-git.tgz";
    sha256 = "0k25kx4gvr046bcnv5mqxbb4483v9p2lk7dvzjkgj2cxrvczmj8b";
  };

  packageName = "fare-quasiquote-readtable";

  asdFilesToKeep = ["fare-quasiquote-readtable.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-quasiquote-readtable DESCRIPTION
    Using fare-quasiquote with named-readtable SHA256
    0k25kx4gvr046bcnv5mqxbb4483v9p2lk7dvzjkgj2cxrvczmj8b URL
    http://beta.quicklisp.org/archive/fare-quasiquote/2020-09-25/fare-quasiquote-20200925-git.tgz
    MD5 7af0a97c445d88acacecfc851496adb3 NAME fare-quasiquote-readtable
    FILENAME fare-quasiquote-readtable DEPS
    ((NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-utils FILENAME fare-utils)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (fare-quasiquote fare-utils named-readtables) VERSION
    fare-quasiquote-20200925-git SIBLINGS
    (fare-quasiquote-extras fare-quasiquote-optima fare-quasiquote) PARASITES
    NIL) */
