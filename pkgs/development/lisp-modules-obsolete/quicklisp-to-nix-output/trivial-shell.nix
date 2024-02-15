/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-shell";
  version = "20180228-git";

  description = "OS and Implementation independent access to the shell";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-shell/2018-02-28/trivial-shell-20180228-git.tgz";
    sha256 = "058gk7fld8v5m84r5fcwl5z8j3pw68xs0jdy9xx6vi1svaxrzngp";
  };

  packageName = "trivial-shell";

  asdFilesToKeep = ["trivial-shell.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-shell DESCRIPTION
    OS and Implementation independent access to the shell SHA256
    058gk7fld8v5m84r5fcwl5z8j3pw68xs0jdy9xx6vi1svaxrzngp URL
    http://beta.quicklisp.org/archive/trivial-shell/2018-02-28/trivial-shell-20180228-git.tgz
    MD5 d7b93648abd06be95148d43d09fa2ed0 NAME trivial-shell FILENAME
    trivial-shell DEPS NIL DEPENDENCIES NIL VERSION 20180228-git SIBLINGS
    (trivial-shell-test) PARASITES NIL) */
