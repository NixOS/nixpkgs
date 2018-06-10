args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.39'';

  parasites = [ "ironclad/tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."nibbles" args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2018-04-30/ironclad-v0.39.tgz'';
    sha256 = ''0nqm6bnxiiv78c33zlr5n53wdkpcfxh1xrx7af6122n29ggzj3h8'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    0nqm6bnxiiv78c33zlr5n53wdkpcfxh1xrx7af6122n29ggzj3h8 URL
    http://beta.quicklisp.org/archive/ironclad/2018-04-30/ironclad-v0.39.tgz
    MD5 f4abb18cbbe173c569d8ed99800d9f9e NAME ironclad FILENAME ironclad DEPS
    ((NAME nibbles FILENAME nibbles) (NAME rt FILENAME rt)) DEPENDENCIES
    (nibbles rt) VERSION v0.39 SIBLINGS (ironclad-text) PARASITES
    (ironclad/tests)) */
