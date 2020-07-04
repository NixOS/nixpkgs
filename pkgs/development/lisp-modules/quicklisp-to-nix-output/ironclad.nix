args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.47'';

  parasites = [ "ironclad/tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."nibbles" args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2019-10-07/ironclad-v0.47.tgz'';
    sha256 = ''1aczr4678jxz9kvzvwfdbgdbqhihsbj1nz6j2qflc9sdr6hx24rk'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    1aczr4678jxz9kvzvwfdbgdbqhihsbj1nz6j2qflc9sdr6hx24rk URL
    http://beta.quicklisp.org/archive/ironclad/2019-10-07/ironclad-v0.47.tgz
    MD5 b82d370b037422fcaf8953857f03b5f6 NAME ironclad FILENAME ironclad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME nibbles FILENAME nibbles) (NAME rt FILENAME rt))
    DEPENDENCIES (alexandria bordeaux-threads nibbles rt) VERSION v0.47
    SIBLINGS (ironclad-text) PARASITES (ironclad/tests)) */
