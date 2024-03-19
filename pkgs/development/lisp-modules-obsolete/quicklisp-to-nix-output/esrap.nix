/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "esrap";
  version = "20211020-git";

  parasites = [ "esrap/tests" ];

  description = "A Packrat / Parsing Grammar / TDPL parser for Common Lisp.";

  deps = [ args."alexandria" args."fiveam" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/esrap/2021-10-20/esrap-20211020-git.tgz";
    sha256 = "06cqvalqsid82an8c4acbf13y65gw8nb4pckm8gv8fknvh4k1x7h";
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    06cqvalqsid82an8c4acbf13y65gw8nb4pckm8gv8fknvh4k1x7h URL
    http://beta.quicklisp.org/archive/esrap/2021-10-20/esrap-20211020-git.tgz
    MD5 9657755b3fe896c1252dc7fdd22320b7 NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES (alexandria fiveam trivial-with-current-source-form) VERSION
    20211020-git SIBLINGS NIL PARASITES (esrap/tests)) */
