args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20170630-git'';

  parasites = [ "esrap/tests" ];

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2017-06-30/esrap-20170630-git.tgz'';
    sha256 = ''172ph55kb3yr0gciybza1rbi6khlnz4vriijvcjkn6m79kdnk1xh'';
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    172ph55kb3yr0gciybza1rbi6khlnz4vriijvcjkn6m79kdnk1xh URL
    http://beta.quicklisp.org/archive/esrap/2017-06-30/esrap-20170630-git.tgz
    MD5 bfabfebc5f5d49106df318ae2798ac45 NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20170630-git SIBLINGS NIL
    PARASITES (esrap/tests)) */
