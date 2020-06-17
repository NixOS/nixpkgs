args @ { fetchurl, ... }:
rec {
  baseName = ''introspect-environment'';
  version = ''20151031-git'';

  description = ''Small interface to portable but nonstandard introspection of CL environments.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/introspect-environment/2015-10-31/introspect-environment-20151031-git.tgz'';
    sha256 = ''0npydsmksbm3nisy9whnivmmhgdira74plmncmaklp7yhqsvwc30'';
  };

  packageName = "introspect-environment";

  asdFilesToKeep = ["introspect-environment.asd"];
  overrides = x: x;
}
/* (SYSTEM introspect-environment DESCRIPTION
    Small interface to portable but nonstandard introspection of CL environments.
    SHA256 0npydsmksbm3nisy9whnivmmhgdira74plmncmaklp7yhqsvwc30 URL
    http://beta.quicklisp.org/archive/introspect-environment/2015-10-31/introspect-environment-20151031-git.tgz
    MD5 3c61088583f11791530edb2e18f5d6f0 NAME introspect-environment FILENAME
    introspect-environment DEPS NIL DEPENDENCIES NIL VERSION 20151031-git
    SIBLINGS (introspect-environment-test) PARASITES NIL) */
