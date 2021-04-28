/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "esrap";
  version = "20201220-git";

  parasites = [ "esrap/tests" ];

  description = "A Packrat / Parsing Grammar / TDPL parser for Common Lisp.";

  deps = [ args."alexandria" args."fiveam" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/esrap/2020-12-20/esrap-20201220-git.tgz";
    sha256 = "0yhi4ay98i81nqv9yjlj321azwmiylsw0afdd6y1c1zflfcrzkrk";
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    0yhi4ay98i81nqv9yjlj321azwmiylsw0afdd6y1c1zflfcrzkrk URL
    http://beta.quicklisp.org/archive/esrap/2020-12-20/esrap-20201220-git.tgz
    MD5 cc33cc8dbc236403f6b285c8eae0ce3b NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES (alexandria fiveam trivial-with-current-source-form) VERSION
    20201220-git SIBLINGS NIL PARASITES (esrap/tests)) */
