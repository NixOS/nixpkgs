/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "contextl";
  version = "20211230-git";

  description = "ContextL is a CLOS extension for Context-oriented Programming (COP).";

  deps = [ args."closer-mop" args."lw-compat" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/contextl/2021-12-30/contextl-20211230-git.tgz";
    sha256 = "1pp7phm5s412a7v9a0f80bq0x96n83v15cx0icxpb40g9kvqfvrd";
  };

  packageName = "contextl";

  asdFilesToKeep = ["contextl.asd"];
  overrides = x: x;
}
/* (SYSTEM contextl DESCRIPTION
    ContextL is a CLOS extension for Context-oriented Programming (COP). SHA256
    1pp7phm5s412a7v9a0f80bq0x96n83v15cx0icxpb40g9kvqfvrd URL
    http://beta.quicklisp.org/archive/contextl/2021-12-30/contextl-20211230-git.tgz
    MD5 0c7093716e2772f90635bcd3c4d23dc0 NAME contextl FILENAME contextl DEPS
    ((NAME closer-mop FILENAME closer-mop) (NAME lw-compat FILENAME lw-compat))
    DEPENDENCIES (closer-mop lw-compat) VERSION 20211230-git SIBLINGS
    (dynamic-wind) PARASITES NIL) */
