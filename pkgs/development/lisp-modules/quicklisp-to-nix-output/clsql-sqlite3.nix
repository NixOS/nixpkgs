args @ { fetchurl, ... }:
{
  baseName = ''clsql-sqlite3'';
  version = ''clsql-20160208-git'';

  description = ''Common Lisp Sqlite3 Driver'';

  deps = [ args."clsql" args."clsql-uffi" args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz'';
    sha256 = ''0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn'';
  };

  packageName = "clsql-sqlite3";

  asdFilesToKeep = ["clsql-sqlite3.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-sqlite3 DESCRIPTION Common Lisp Sqlite3 Driver SHA256
    0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn URL
    http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz
    MD5 d1da7688361337a7de4fe7452c225a06 NAME clsql-sqlite3 FILENAME
    clsql-sqlite3 DEPS
    ((NAME clsql FILENAME clsql) (NAME clsql-uffi FILENAME clsql-uffi)
     (NAME uffi FILENAME uffi))
    DEPENDENCIES (clsql clsql-uffi uffi) VERSION clsql-20160208-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-tests
     clsql-uffi clsql)
    PARASITES NIL) */
