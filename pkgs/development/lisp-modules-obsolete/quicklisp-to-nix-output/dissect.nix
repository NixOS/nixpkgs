/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dissect";
  version = "20210531-git";

  description = "A lib for introspecting the call stack and active restarts.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/dissect/2021-05-31/dissect-20210531-git.tgz";
    sha256 = "07f5sk2nvhj5jjrw5k561dfnwbjcaniqi2z7wgdrw8qb9h8kkkzk";
  };

  packageName = "dissect";

  asdFilesToKeep = ["dissect.asd"];
  overrides = x: x;
}
/* (SYSTEM dissect DESCRIPTION
    A lib for introspecting the call stack and active restarts. SHA256
    07f5sk2nvhj5jjrw5k561dfnwbjcaniqi2z7wgdrw8qb9h8kkkzk URL
    http://beta.quicklisp.org/archive/dissect/2021-05-31/dissect-20210531-git.tgz
    MD5 41dfb42dc93aa41d825c167fe173fa89 NAME dissect FILENAME dissect DEPS NIL
    DEPENDENCIES NIL VERSION 20210531-git SIBLINGS NIL PARASITES NIL) */
