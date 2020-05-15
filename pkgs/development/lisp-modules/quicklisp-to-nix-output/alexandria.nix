args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20191227-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2019-12-27/alexandria-20191227-git.tgz'';
    sha256 = ''1vq19i7mcx3dk8vd8l92ld33birs9qhwcs7hbwwphvrwsrxbnd89'';
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    1vq19i7mcx3dk8vd8l92ld33birs9qhwcs7hbwwphvrwsrxbnd89 URL
    http://beta.quicklisp.org/archive/alexandria/2019-12-27/alexandria-20191227-git.tgz
    MD5 634105318a9c82a2a2729d0305c91667 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20191227-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
