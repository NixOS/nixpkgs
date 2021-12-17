/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "named-readtables";
  version = "20210531-git";

  parasites = [ "named-readtables/test" ];

  description = "Library that creates a namespace for named readtable
  akin to the namespace of packages.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/named-readtables/2021-05-31/named-readtables-20210531-git.tgz";
    sha256 = "1z9c02924wqmxmcr1m1fzhw0gib138yllg70j5imiww9dmqbm9wf";
  };

  packageName = "named-readtables";

  asdFilesToKeep = ["named-readtables.asd"];
  overrides = x: x;
}
/* (SYSTEM named-readtables DESCRIPTION
    Library that creates a namespace for named readtable
  akin to the namespace of packages.
    SHA256 1z9c02924wqmxmcr1m1fzhw0gib138yllg70j5imiww9dmqbm9wf URL
    http://beta.quicklisp.org/archive/named-readtables/2021-05-31/named-readtables-20210531-git.tgz
    MD5 a79f2cc78e84c4b474f818132c8cc4d8 NAME named-readtables FILENAME
    named-readtables DEPS NIL DEPENDENCIES NIL VERSION 20210531-git SIBLINGS
    NIL PARASITES (named-readtables/test)) */
