/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-date";
  version = "postmodern-20211209-git";

  parasites = [ "simple-date/tests" ];

  description = "Simple date library that can be used with postmodern";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-12-09/postmodern-20211209-git.tgz";
    sha256 = "1qcbg31mz5r7ibmq2y7r3vqvdwpznxvwdnwd94hfil7pg4j119d6";
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION
    Simple date library that can be used with postmodern SHA256
    1qcbg31mz5r7ibmq2y7r3vqvdwpznxvwdnwd94hfil7pg4j119d6 URL
    http://beta.quicklisp.org/archive/postmodern/2021-12-09/postmodern-20211209-git.tgz
    MD5 6d14c4b5fec085594dc66d520174e0e6 NAME simple-date FILENAME simple-date
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    postmodern-20211209-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/tests)) */
