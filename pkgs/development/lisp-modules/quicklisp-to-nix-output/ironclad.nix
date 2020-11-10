args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.51'';

  parasites = [ "ironclad/tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2020-09-25/ironclad-v0.51.tgz'';
    sha256 = ''0zfazyvg91fxr9gm195qwwf1y5qdci7i1cwzpv0fggxhylpkswrn'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    0zfazyvg91fxr9gm195qwwf1y5qdci7i1cwzpv0fggxhylpkswrn URL
    http://beta.quicklisp.org/archive/ironclad/2020-09-25/ironclad-v0.51.tgz
    MD5 23b0b6a654bceca511e100fdc976e107 NAME ironclad FILENAME ironclad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME rt FILENAME rt))
    DEPENDENCIES (alexandria bordeaux-threads rt) VERSION v0.51 SIBLINGS
    (ironclad-text) PARASITES (ironclad/tests)) */
