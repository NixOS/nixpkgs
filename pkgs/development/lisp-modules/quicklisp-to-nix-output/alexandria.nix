args @ { fetchurl, ... }:
{
  baseName = ''alexandria'';
  version = ''20190710-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2019-07-10/alexandria-20190710-git.tgz'';
    sha256 = ''0127d5yyq46dpffvr4hla6d3ryiml48mxd2r6cgbg3mgz3b2nr70'';
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    0127d5yyq46dpffvr4hla6d3ryiml48mxd2r6cgbg3mgz3b2nr70 URL
    http://beta.quicklisp.org/archive/alexandria/2019-07-10/alexandria-20190710-git.tgz
    MD5 2b5abc0a266aeafe9029bf26db90b292 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
