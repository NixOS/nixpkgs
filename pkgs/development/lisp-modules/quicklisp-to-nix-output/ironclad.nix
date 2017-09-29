args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.34'';

  parasites = [ "ironclad-tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."nibbles" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2017-06-30/ironclad-v0.34.tgz'';
    sha256 = ''08xlnzs7hzbr0sa4aff4xb0b60dxcpad7fb5xsnjn3qjs7yydxk0'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    08xlnzs7hzbr0sa4aff4xb0b60dxcpad7fb5xsnjn3qjs7yydxk0 URL
    http://beta.quicklisp.org/archive/ironclad/2017-06-30/ironclad-v0.34.tgz
    MD5 82db632975aa83b0dce3412c1aff4a80 NAME ironclad FILENAME ironclad DEPS
    ((NAME nibbles FILENAME nibbles)) DEPENDENCIES (nibbles) VERSION v0.34
    SIBLINGS (ironclad-text) PARASITES (ironclad-tests)) */
