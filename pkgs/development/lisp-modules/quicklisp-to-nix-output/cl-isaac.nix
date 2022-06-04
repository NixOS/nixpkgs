/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-isaac";
  version = "20150804-git";

  description = "Optimized Common Lisp version of Bob Jenkins' ISAAC-32 and ISAAC-64 algorithms, fast cryptographic random number generators.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-isaac/2015-08-04/cl-isaac-20150804-git.tgz";
    sha256 = "0z5h5v3q1xi83cvyi1a6v2dr0yfx5cmj1l9lzcsxv5szf58zwkya";
  };

  packageName = "cl-isaac";

  asdFilesToKeep = ["cl-isaac.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-isaac DESCRIPTION
    Optimized Common Lisp version of Bob Jenkins' ISAAC-32 and ISAAC-64 algorithms, fast cryptographic random number generators.
    SHA256 0z5h5v3q1xi83cvyi1a6v2dr0yfx5cmj1l9lzcsxv5szf58zwkya URL
    http://beta.quicklisp.org/archive/cl-isaac/2015-08-04/cl-isaac-20150804-git.tgz
    MD5 03beb7c110fa638fa32c4afcb5a9d604 NAME cl-isaac FILENAME cl-isaac DEPS
    NIL DEPENDENCIES NIL VERSION 20150804-git SIBLINGS NIL PARASITES NIL) */
