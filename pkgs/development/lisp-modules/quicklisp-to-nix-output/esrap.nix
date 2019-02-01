args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20190107-git'';

  parasites = [ "esrap/tests" ];

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2019-01-07/esrap-20190107-git.tgz'';
    sha256 = ''0kb4szcd7v4qj56p0yg1abvk79is6p5myri3gakzm87l2nmg15xs'';
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    0kb4szcd7v4qj56p0yg1abvk79is6p5myri3gakzm87l2nmg15xs URL
    http://beta.quicklisp.org/archive/esrap/2019-01-07/esrap-20190107-git.tgz
    MD5 b8c98e84e3c63e4e3ce2f6c8b4d4bab7 NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20190107-git SIBLINGS NIL
    PARASITES (esrap/tests)) */
