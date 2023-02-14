/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "esrap";
  version = "20220220-git";

  parasites = [ "esrap/tests" ];

  description = "A Packrat / Parsing Grammar / TDPL parser for Common Lisp.";

  deps = [ args."alexandria" args."fiveam" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/esrap/2022-02-20/esrap-20220220-git.tgz";
    sha256 = "136wly0wfpvl974lh05k5k0xi61xi1p3afd62dqxvjkw64pi29m3";
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    136wly0wfpvl974lh05k5k0xi61xi1p3afd62dqxvjkw64pi29m3 URL
    http://beta.quicklisp.org/archive/esrap/2022-02-20/esrap-20220220-git.tgz
    MD5 da6912f125df3fee0175e7cfd6a9ed8d NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES (alexandria fiveam trivial-with-current-source-form) VERSION
    20220220-git SIBLINGS NIL PARASITES (esrap/tests)) */
