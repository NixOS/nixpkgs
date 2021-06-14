/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "introspect-environment";
  version = "20200715-git";

  description = "Small interface to portable but nonstandard introspection of CL environments.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/introspect-environment/2020-07-15/introspect-environment-20200715-git.tgz";
    sha256 = "1m2vqpbrvjb0mkmi2n5rg3j0dr68hyv23lbw6s474hylx02nw5ns";
  };

  packageName = "introspect-environment";

  asdFilesToKeep = ["introspect-environment.asd"];
  overrides = x: x;
}
/* (SYSTEM introspect-environment DESCRIPTION
    Small interface to portable but nonstandard introspection of CL environments.
    SHA256 1m2vqpbrvjb0mkmi2n5rg3j0dr68hyv23lbw6s474hylx02nw5ns URL
    http://beta.quicklisp.org/archive/introspect-environment/2020-07-15/introspect-environment-20200715-git.tgz
    MD5 d129641b18376741e7106bd13e476cb8 NAME introspect-environment FILENAME
    introspect-environment DEPS NIL DEPENDENCIES NIL VERSION 20200715-git
    SIBLINGS (introspect-environment-test) PARASITES NIL) */
