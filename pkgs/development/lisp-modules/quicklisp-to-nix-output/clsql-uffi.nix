args @ { fetchurl, ... }:
{
  baseName = ''clsql-uffi'';
  version = ''clsql-20160208-git'';

  description = ''Common UFFI Helper functions for Common Lisp SQL Interface Library'';

  deps = [ args."clsql" args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz'';
    sha256 = ''0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn'';
  };

  packageName = "clsql-uffi";

  asdFilesToKeep = ["clsql-uffi.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-uffi DESCRIPTION
    Common UFFI Helper functions for Common Lisp SQL Interface Library SHA256
    0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn URL
    http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz
    MD5 d1da7688361337a7de4fe7452c225a06 NAME clsql-uffi FILENAME clsql-uffi
    DEPS ((NAME clsql FILENAME clsql) (NAME uffi FILENAME uffi)) DEPENDENCIES
    (clsql uffi) VERSION clsql-20160208-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-sqlite3
     clsql-tests clsql)
    PARASITES NIL) */
