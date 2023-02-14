/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-garbage";
  version = "20211230-git";

  parasites = [ "trivial-garbage/tests" ];

  description = "Portable finalizers, weak hash-tables and weak pointers.";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-garbage/2021-12-30/trivial-garbage-20211230-git.tgz";
    sha256 = "10vv19i3vdli165j7hkmvmrmpkf4c9c6d4b26wwrfdj5cvm2l7gp";
  };

  packageName = "trivial-garbage";

  asdFilesToKeep = ["trivial-garbage.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-garbage DESCRIPTION
    Portable finalizers, weak hash-tables and weak pointers. SHA256
    10vv19i3vdli165j7hkmvmrmpkf4c9c6d4b26wwrfdj5cvm2l7gp URL
    http://beta.quicklisp.org/archive/trivial-garbage/2021-12-30/trivial-garbage-20211230-git.tgz
    MD5 6e2b3c0360733f30c7ed36357eb8d54a NAME trivial-garbage FILENAME
    trivial-garbage DEPS ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION
    20211230-git SIBLINGS NIL PARASITES (trivial-garbage/tests)) */
