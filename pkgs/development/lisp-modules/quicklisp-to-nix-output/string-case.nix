/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "string-case";
  version = "20180711-git";

  description = "string-case is a macro that generates specialised decision trees to dispatch on string equality";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/string-case/2018-07-11/string-case-20180711-git.tgz";
    sha256 = "1n36ign4bv0idw14zyayn6i0n3iaff9yw92kpjh3qmdcq3asv90z";
  };

  packageName = "string-case";

  asdFilesToKeep = ["string-case.asd"];
  overrides = x: x;
}
/* (SYSTEM string-case DESCRIPTION
    string-case is a macro that generates specialised decision trees to dispatch on string equality
    SHA256 1n36ign4bv0idw14zyayn6i0n3iaff9yw92kpjh3qmdcq3asv90z URL
    http://beta.quicklisp.org/archive/string-case/2018-07-11/string-case-20180711-git.tgz
    MD5 145c4e13f1e90a070b0a95ca979a9680 NAME string-case FILENAME string-case
    DEPS NIL DEPENDENCIES NIL VERSION 20180711-git SIBLINGS NIL PARASITES NIL) */
