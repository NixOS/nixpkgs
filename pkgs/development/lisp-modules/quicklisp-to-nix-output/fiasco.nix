args @ { fetchurl, ... }:
rec {
  baseName = ''fiasco'';
  version = ''20171227-git'';

  parasites = [ "fiasco-self-tests" ];

  description = ''A Common Lisp test framework that treasures your failures, logical continuation of Stefil.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fiasco/2017-12-27/fiasco-20171227-git.tgz'';
    sha256 = ''1kv88yp4vjglahvknaxcdsp2kiwbs1nm94f857mkr2pmy87qbqx2'';
  };

  packageName = "fiasco";

  asdFilesToKeep = ["fiasco.asd"];
  overrides = x: x;
}
/* (SYSTEM fiasco DESCRIPTION
    A Common Lisp test framework that treasures your failures, logical continuation of Stefil.
    SHA256 1kv88yp4vjglahvknaxcdsp2kiwbs1nm94f857mkr2pmy87qbqx2 URL
    http://beta.quicklisp.org/archive/fiasco/2017-12-27/fiasco-20171227-git.tgz
    MD5 3cc915e91f18617eb3d436b6fea9dd49 NAME fiasco FILENAME fiasco DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20171227-git SIBLINGS NIL PARASITES (fiasco-self-tests)) */
