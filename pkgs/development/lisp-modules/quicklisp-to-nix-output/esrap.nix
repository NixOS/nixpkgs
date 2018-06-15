args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20180430-git'';

  parasites = [ "esrap/tests" ];

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2018-04-30/esrap-20180430-git.tgz'';
    sha256 = ''1wv33nzsm6hinr4blfih9napd0gqx8jf8dnnp224h95lhn9fxaav'';
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    1wv33nzsm6hinr4blfih9napd0gqx8jf8dnnp224h95lhn9fxaav URL
    http://beta.quicklisp.org/archive/esrap/2018-04-30/esrap-20180430-git.tgz
    MD5 51efcf9b228ebfe63831db8ba797b0e8 NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20180430-git SIBLINGS NIL
    PARASITES (esrap/tests)) */
