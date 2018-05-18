args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20180131-git'';

  parasites = [ "esrap/tests" ];

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2018-01-31/esrap-20180131-git.tgz'';
    sha256 = ''1kgr77w1ya125c04h6szxhzkxnq578rdf8f399wadqkav6x9dpkc'';
  };

  packageName = "esrap";

  asdFilesToKeep = ["esrap.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap DESCRIPTION
    A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256
    1kgr77w1ya125c04h6szxhzkxnq578rdf8f399wadqkav6x9dpkc URL
    http://beta.quicklisp.org/archive/esrap/2018-01-31/esrap-20180131-git.tgz
    MD5 89b22e10575198b9f680e0c4e90bec2c NAME esrap FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20180131-git SIBLINGS NIL
    PARASITES (esrap/tests)) */
