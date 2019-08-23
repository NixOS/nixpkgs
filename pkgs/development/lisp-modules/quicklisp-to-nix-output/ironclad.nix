args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.44'';

  parasites = [ "ironclad/tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."nibbles" args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2018-12-10/ironclad-v0.44.tgz'';
    sha256 = ''0qxvvv9hp6843s3n4fnj2fl26xzdpnk91j1h0sgi8v0fbfakwl2y'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    0qxvvv9hp6843s3n4fnj2fl26xzdpnk91j1h0sgi8v0fbfakwl2y URL
    http://beta.quicklisp.org/archive/ironclad/2018-12-10/ironclad-v0.44.tgz
    MD5 ebce1cbac421a5d7ad461cdaed4ac863 NAME ironclad FILENAME ironclad DEPS
    ((NAME nibbles FILENAME nibbles) (NAME rt FILENAME rt)) DEPENDENCIES
    (nibbles rt) VERSION v0.44 SIBLINGS (ironclad-text) PARASITES
    (ironclad/tests)) */
