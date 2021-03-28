args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20200925-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2020-09-25/alexandria-20200925-git.tgz'';
    sha256 = ''1cpvnzfs807ah07hrk8kplim6ryzqs4r35ym03cpky5xdl8c89fl'';
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    1cpvnzfs807ah07hrk8kplim6ryzqs4r35ym03cpky5xdl8c89fl URL
    http://beta.quicklisp.org/archive/alexandria/2020-09-25/alexandria-20200925-git.tgz
    MD5 59c8237a854de6f4f93328cd5747cd14 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20200925-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
