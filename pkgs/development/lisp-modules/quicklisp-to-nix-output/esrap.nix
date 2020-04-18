args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20191227-git'';

  parasites = [ "esrap/tests" ];

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2019-12-27/esrap-20191227-git.tgz'';
    sha256 = ''0614lb8iyraihx2m81manlyd3x89snsn9a1mihlil85piswdbiv8'';
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    0614lb8iyraihx2m81manlyd3x89snsn9a1mihlil85piswdbiv8 URL
    http://beta.quicklisp.org/archive/esrap/2019-12-27/esrap-20191227-git.tgz
    MD5 8dd58ffc605bba6eec614bdea573978b NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20191227-git SIBLINGS NIL
    PARASITES (esrap/tests)) */
