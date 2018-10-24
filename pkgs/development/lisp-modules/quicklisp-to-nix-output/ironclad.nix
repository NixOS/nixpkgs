args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.42'';

  parasites = [ "ironclad/tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."nibbles" args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2018-08-31/ironclad-v0.42.tgz'';
    sha256 = ''1rrw0mhvja407ycryw56wwm45cpf3dc73h965smy75ddha4xn7zr'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    1rrw0mhvja407ycryw56wwm45cpf3dc73h965smy75ddha4xn7zr URL
    http://beta.quicklisp.org/archive/ironclad/2018-08-31/ironclad-v0.42.tgz
    MD5 18f2dbc9dbff97de9ea44af5344485b5 NAME ironclad FILENAME ironclad DEPS
    ((NAME nibbles FILENAME nibbles) (NAME rt FILENAME rt)) DEPENDENCIES
    (nibbles rt) VERSION v0.42 SIBLINGS (ironclad-text) PARASITES
    (ironclad/tests)) */
