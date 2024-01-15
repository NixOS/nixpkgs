/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "introspect-environment";
  version = "20210807-git";

  description = "Small interface to portable but nonstandard introspection of CL environments.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/introspect-environment/2021-08-07/introspect-environment-20210807-git.tgz";
    sha256 = "124rnbcjygw7wm07bpcibsqkvsqxhr8pq42p7phw39kmcp9hns4j";
  };

  packageName = "introspect-environment";

  asdFilesToKeep = ["introspect-environment.asd"];
  overrides = x: x;
}
/* (SYSTEM introspect-environment DESCRIPTION
    Small interface to portable but nonstandard introspection of CL environments.
    SHA256 124rnbcjygw7wm07bpcibsqkvsqxhr8pq42p7phw39kmcp9hns4j URL
    http://beta.quicklisp.org/archive/introspect-environment/2021-08-07/introspect-environment-20210807-git.tgz
    MD5 f9d4e1208146e9435c2ce1b82a87a209 NAME introspect-environment FILENAME
    introspect-environment DEPS NIL DEPENDENCIES NIL VERSION 20210807-git
    SIBLINGS (introspect-environment-test) PARASITES NIL) */
