/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "smug";
  version = "20211230-git";

  description = "SMUG: Simple Monadic Uber Go-into, Parsing made easy.";

  deps = [ args."asdf-package-system" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/smug/2021-12-30/smug-20211230-git.tgz";
    sha256 = "0j8w8vkxd76r9a6v6yrhgs7k1hv1fpnzkhjykq9dssnnz5cdpb6p";
  };

  packageName = "smug";

  asdFilesToKeep = ["smug.asd"];
  overrides = x: x;
}
/* (SYSTEM smug DESCRIPTION
    SMUG: Simple Monadic Uber Go-into, Parsing made easy. SHA256
    0j8w8vkxd76r9a6v6yrhgs7k1hv1fpnzkhjykq9dssnnz5cdpb6p URL
    http://beta.quicklisp.org/archive/smug/2021-12-30/smug-20211230-git.tgz MD5
    8661c0d2306a06f0df4bcfe94b48ab7e NAME smug FILENAME smug DEPS
    ((NAME asdf-package-system FILENAME asdf-package-system)) DEPENDENCIES
    (asdf-package-system) VERSION 20211230-git SIBLINGS NIL PARASITES NIL) */
