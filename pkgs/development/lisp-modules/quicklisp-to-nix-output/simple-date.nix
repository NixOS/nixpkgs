/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-date";
  version = "postmodern-20220220-git";

  parasites = [ "simple-date/tests" ];

  description = "Simple date library that can be used with postmodern";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2022-02-20/postmodern-20220220-git.tgz";
    sha256 = "17g6360phwcjy28j1gjj77p67y6fl1l9nrpgf9x9jmmx16mk44d5";
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION
    Simple date library that can be used with postmodern SHA256
    17g6360phwcjy28j1gjj77p67y6fl1l9nrpgf9x9jmmx16mk44d5 URL
    http://beta.quicklisp.org/archive/postmodern/2022-02-20/postmodern-20220220-git.tgz
    MD5 d30fbcddd0b858445622f4f04676561e NAME simple-date FILENAME simple-date
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    postmodern-20220220-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/tests)) */
