/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-date";
  version = "postmodern-20210124-git";

  parasites = [ "simple-date/tests" ];

  description = "Simple date library that can be used with postmodern";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-01-24/postmodern-20210124-git.tgz";
    sha256 = "1fl103fga5iq2gf1p15xvbrmmjrcv2bbi3lz1zv32j6smy5aymhc";
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION
    Simple date library that can be used with postmodern SHA256
    1fl103fga5iq2gf1p15xvbrmmjrcv2bbi3lz1zv32j6smy5aymhc URL
    http://beta.quicklisp.org/archive/postmodern/2021-01-24/postmodern-20210124-git.tgz
    MD5 05c2c5f4d2354a5fa69a32b7b96f8ff8 NAME simple-date FILENAME simple-date
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    postmodern-20210124-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/tests)) */
