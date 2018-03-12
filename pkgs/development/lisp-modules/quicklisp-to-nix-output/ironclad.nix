args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.37'';

  parasites = [ "ironclad/tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."nibbles" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2017-11-30/ironclad-v0.37.tgz'';
    sha256 = ''061ln65yj9psch84nmsjrrlq41bkfv6iyg8sd9kpdc75lfc0vpi2'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    061ln65yj9psch84nmsjrrlq41bkfv6iyg8sd9kpdc75lfc0vpi2 URL
    http://beta.quicklisp.org/archive/ironclad/2017-11-30/ironclad-v0.37.tgz
    MD5 9d8734764eead79f3a5d230b8e800d8f NAME ironclad FILENAME ironclad DEPS
    ((NAME nibbles FILENAME nibbles)) DEPENDENCIES (nibbles) VERSION v0.37
    SIBLINGS (ironclad-text) PARASITES (ironclad/tests)) */
