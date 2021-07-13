/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-date";
  version = "postmodern-20210411-git";

  parasites = [ "simple-date/tests" ];

  description = "Simple date library that can be used with postmodern";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-04-11/postmodern-20210411-git.tgz";
    sha256 = "0q8izkkddmqq5sw55chkx6jrycawgchaknik5i84vynv50zirsbw";
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION
    Simple date library that can be used with postmodern SHA256
    0q8izkkddmqq5sw55chkx6jrycawgchaknik5i84vynv50zirsbw URL
    http://beta.quicklisp.org/archive/postmodern/2021-04-11/postmodern-20210411-git.tgz
    MD5 8a75a05ba9e371f672f2620d40724cb2 NAME simple-date FILENAME simple-date
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    postmodern-20210411-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/tests)) */
