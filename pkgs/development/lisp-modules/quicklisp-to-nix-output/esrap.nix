args @ { fetchurl, ... }:
{
  baseName = ''esrap'';
  version = ''20190521-git'';

  parasites = [ "esrap/tests" ];

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2019-05-21/esrap-20190521-git.tgz'';
    sha256 = ''0kbb05735yhkh2vply6hdk2jn43s8pym8j6jqip13qyaaiax6w5q'';
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    0kbb05735yhkh2vply6hdk2jn43s8pym8j6jqip13qyaaiax6w5q URL
    http://beta.quicklisp.org/archive/esrap/2019-05-21/esrap-20190521-git.tgz
    MD5 401362d64d644f02824de03697435883 NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20190521-git SIBLINGS NIL
    PARASITES (esrap/tests)) */
