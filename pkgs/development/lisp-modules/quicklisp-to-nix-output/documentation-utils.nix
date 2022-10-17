/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "documentation-utils";
  version = "20190710-git";

  description = "A few simple tools to help you with documenting your library.";

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/documentation-utils/2019-07-10/documentation-utils-20190710-git.tgz";
    sha256 = "1n3z8sw75k2jjpsg6ch5g9s4v56y96dbs4338ajrfdsk3pk4wgj3";
  };

  packageName = "documentation-utils";

  asdFilesToKeep = ["documentation-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM documentation-utils DESCRIPTION
    A few simple tools to help you with documenting your library. SHA256
    1n3z8sw75k2jjpsg6ch5g9s4v56y96dbs4338ajrfdsk3pk4wgj3 URL
    http://beta.quicklisp.org/archive/documentation-utils/2019-07-10/documentation-utils-20190710-git.tgz
    MD5 4f45f511ac55008b8b8aa04f7feaa2d4 NAME documentation-utils FILENAME
    documentation-utils DEPS ((NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (trivial-indent) VERSION 20190710-git SIBLINGS
    (multilang-documentation-utils) PARASITES NIL) */
