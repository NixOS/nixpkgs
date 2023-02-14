/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "introspect-environment";
  version = "20220220-git";

  description = "Small interface to portable but nonstandard introspection of CL environments.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/introspect-environment/2022-02-20/introspect-environment-20220220-git.tgz";
    sha256 = "0d1cay632hq5sjpq6lvalwba707cipvrdj77iw1m1dm04rawbaqz";
  };

  packageName = "introspect-environment";

  asdFilesToKeep = ["introspect-environment.asd"];
  overrides = x: x;
}
/* (SYSTEM introspect-environment DESCRIPTION
    Small interface to portable but nonstandard introspection of CL environments.
    SHA256 0d1cay632hq5sjpq6lvalwba707cipvrdj77iw1m1dm04rawbaqz URL
    http://beta.quicklisp.org/archive/introspect-environment/2022-02-20/introspect-environment-20220220-git.tgz
    MD5 e2a9864b2f9792f31ad20b44ea25a58b NAME introspect-environment FILENAME
    introspect-environment DEPS NIL DEPENDENCIES NIL VERSION 20220220-git
    SIBLINGS (introspect-environment-test) PARASITES NIL) */
