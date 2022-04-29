/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "smug";
  version = "20160421-git";

  description = "SMUG: Simple Monadic Uber Go-into, Parsing made easy.";

  deps = [ args."asdf-package-system" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/smug/2016-04-21/smug-20160421-git.tgz";
    sha256 = "0f9ig6r0cm1sbhkasx1v27204rmrjbzgwc49d9hy4zn29ffrg0h2";
  };

  packageName = "smug";

  asdFilesToKeep = ["smug.asd"];
  overrides = x: x;
}
/* (SYSTEM smug DESCRIPTION
    SMUG: Simple Monadic Uber Go-into, Parsing made easy. SHA256
    0f9ig6r0cm1sbhkasx1v27204rmrjbzgwc49d9hy4zn29ffrg0h2 URL
    http://beta.quicklisp.org/archive/smug/2016-04-21/smug-20160421-git.tgz MD5
    8139d7813bb3130497b6da3bb4cb8924 NAME smug FILENAME smug DEPS
    ((NAME asdf-package-system FILENAME asdf-package-system)) DEPENDENCIES
    (asdf-package-system) VERSION 20160421-git SIBLINGS NIL PARASITES NIL) */
