args @ { fetchurl, ... }:
rec {
  baseName = ''string-case'';
  version = ''20151218-git'';

  description = ''string-case is a macro that generates specialised decision trees to dispatch on string equality'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/string-case/2015-12-18/string-case-20151218-git.tgz'';
    sha256 = ''0l7bcysm1hwxaxxbld9fs0hj30739wf2ys3n6fhfdy9m5rz1cfbw'';
  };

  packageName = "string-case";

  asdFilesToKeep = ["string-case.asd"];
  overrides = x: x;
}
/* (SYSTEM string-case DESCRIPTION
    string-case is a macro that generates specialised decision trees to dispatch on string equality
    SHA256 0l7bcysm1hwxaxxbld9fs0hj30739wf2ys3n6fhfdy9m5rz1cfbw URL
    http://beta.quicklisp.org/archive/string-case/2015-12-18/string-case-20151218-git.tgz
    MD5 fb747ba1276f0173f875876425b1acc3 NAME string-case FILENAME string-case
    DEPS NIL DEPENDENCIES NIL VERSION 20151218-git SIBLINGS NIL PARASITES NIL) */
