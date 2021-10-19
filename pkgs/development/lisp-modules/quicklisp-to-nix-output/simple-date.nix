/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-date";
  version = "postmodern-20210807-git";

  parasites = [ "simple-date/tests" ];

  description = "Simple date library that can be used with postmodern";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-08-07/postmodern-20210807-git.tgz";
    sha256 = "01l0zk5f3z1cxb6rspvagjl1fy8v3jwm62p2975cgl45aspp18fp";
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION
    Simple date library that can be used with postmodern SHA256
    01l0zk5f3z1cxb6rspvagjl1fy8v3jwm62p2975cgl45aspp18fp URL
    http://beta.quicklisp.org/archive/postmodern/2021-08-07/postmodern-20210807-git.tgz
    MD5 aa951f2ad4ce59fce588a62afa34f3ec NAME simple-date FILENAME simple-date
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    postmodern-20210807-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/tests)) */
