/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "marshal";
  version = "cl-20211020-git";

  description = "marshal: Simple (de)serialization of Lisp datastructures.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-marshal/2021-10-20/cl-marshal-20211020-git.tgz";
    sha256 = "0zv4bpj352frdrsk7r1yc67385h2n00cy19nz3b72sznsjynqvk8";
  };

  packageName = "marshal";

  asdFilesToKeep = ["marshal.asd"];
  overrides = x: x;
}
/* (SYSTEM marshal DESCRIPTION
    marshal: Simple (de)serialization of Lisp datastructures. SHA256
    0zv4bpj352frdrsk7r1yc67385h2n00cy19nz3b72sznsjynqvk8 URL
    http://beta.quicklisp.org/archive/cl-marshal/2021-10-20/cl-marshal-20211020-git.tgz
    MD5 52eaad7da569610099d15c1d91020e17 NAME marshal FILENAME marshal DEPS NIL
    DEPENDENCIES NIL VERSION cl-20211020-git SIBLINGS (marshal-tests) PARASITES
    NIL) */
