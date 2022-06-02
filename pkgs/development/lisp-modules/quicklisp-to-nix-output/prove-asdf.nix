/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "prove-asdf";
  version = "prove-20200218-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/prove/2020-02-18/prove-20200218-git.tgz";
    sha256 = "1sv3zyam9sdmyis5lyv0khvw82q7bcpsycpj9b3bsv9isb4j30zn";
  };

  packageName = "prove-asdf";

  asdFilesToKeep = ["prove-asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM prove-asdf DESCRIPTION System lacks description SHA256
    1sv3zyam9sdmyis5lyv0khvw82q7bcpsycpj9b3bsv9isb4j30zn URL
    http://beta.quicklisp.org/archive/prove/2020-02-18/prove-20200218-git.tgz
    MD5 85780b65e84c17a78d658364b8c4d11b NAME prove-asdf FILENAME prove-asdf
    DEPS NIL DEPENDENCIES NIL VERSION prove-20200218-git SIBLINGS
    (cl-test-more prove-test prove) PARASITES NIL) */
