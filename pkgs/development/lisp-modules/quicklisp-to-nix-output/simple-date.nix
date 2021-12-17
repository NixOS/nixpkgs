/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-date";
  version = "postmodern-20211020-git";

  parasites = [ "simple-date/tests" ];

  description = "Simple date library that can be used with postmodern";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-10-20/postmodern-20211020-git.tgz";
    sha256 = "0iw0sbjra3g57ivfqgx3c97mlcdzlh2kgqp12d1r2i9pw8z0ckh6";
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION
    Simple date library that can be used with postmodern SHA256
    0iw0sbjra3g57ivfqgx3c97mlcdzlh2kgqp12d1r2i9pw8z0ckh6 URL
    http://beta.quicklisp.org/archive/postmodern/2021-10-20/postmodern-20211020-git.tgz
    MD5 84f4ad8ce7ac0f7f78cbfcf2f0bd3aa4 NAME simple-date FILENAME simple-date
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    postmodern-20211020-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/tests)) */
