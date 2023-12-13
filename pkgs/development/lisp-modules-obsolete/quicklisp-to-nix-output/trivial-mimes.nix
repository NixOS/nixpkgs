/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-mimes";
  version = "20200715-git";

  description = "Tiny library to detect mime types in files.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-mimes/2020-07-15/trivial-mimes-20200715-git.tgz";
    sha256 = "10mk1v5ad0m3bg5pl7lqhh827jvg5jb896807vmi8wznwk7zaif1";
  };

  packageName = "trivial-mimes";

  asdFilesToKeep = ["trivial-mimes.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-mimes DESCRIPTION
    Tiny library to detect mime types in files. SHA256
    10mk1v5ad0m3bg5pl7lqhh827jvg5jb896807vmi8wznwk7zaif1 URL
    http://beta.quicklisp.org/archive/trivial-mimes/2020-07-15/trivial-mimes-20200715-git.tgz
    MD5 6f400805470232e87b3f69b9239b2b55 NAME trivial-mimes FILENAME
    trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20200715-git SIBLINGS NIL
    PARASITES NIL) */
