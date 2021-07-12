/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "ironclad";
  version = "v0.55";

  parasites = [ "ironclad/tests" ];

  description = "A cryptographic toolkit written in pure Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/ironclad/2021-04-11/ironclad-v0.55.tgz";
    sha256 = "0vdqaad9i3dkz6z2y1iqmh6m77kc9jy49xh9bysgywl0gfdyhnq6";
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    0vdqaad9i3dkz6z2y1iqmh6m77kc9jy49xh9bysgywl0gfdyhnq6 URL
    http://beta.quicklisp.org/archive/ironclad/2021-04-11/ironclad-v0.55.tgz
    MD5 c3c4a88e71ef37c9604662071069afcc NAME ironclad FILENAME ironclad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME rt FILENAME rt))
    DEPENDENCIES (alexandria bordeaux-threads rt) VERSION v0.55 SIBLINGS
    (ironclad-text) PARASITES (ironclad/tests)) */
