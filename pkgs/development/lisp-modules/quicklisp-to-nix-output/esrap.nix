args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20200325-git'';

  parasites = [ "esrap/tests" ];

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2020-03-25/esrap-20200325-git.tgz'';
    sha256 = ''1pwgjsm19nxx8d4iwbn3x7g08r6qyq1vmp9m83m87r53597b3a68'';
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    1pwgjsm19nxx8d4iwbn3x7g08r6qyq1vmp9m83m87r53597b3a68 URL
    http://beta.quicklisp.org/archive/esrap/2020-03-25/esrap-20200325-git.tgz
    MD5 bcc4e07536153072edf1d57f871bc142 NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20200325-git SIBLINGS NIL
    PARASITES (esrap/tests)) */
