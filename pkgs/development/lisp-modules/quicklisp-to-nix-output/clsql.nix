args @ { fetchurl, ... }:
{
  baseName = ''clsql'';
  version = ''20160208-git'';

  description = ''Common Lisp SQL Interface library'';

  deps = [ args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz'';
    sha256 = ''0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn'';
  };

  packageName = "clsql";

  asdFilesToKeep = ["clsql.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql DESCRIPTION Common Lisp SQL Interface library SHA256
    0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn URL
    http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz
    MD5 d1da7688361337a7de4fe7452c225a06 NAME clsql FILENAME clsql DEPS
    ((NAME uffi FILENAME uffi)) DEPENDENCIES (uffi) VERSION 20160208-git
    SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-sqlite3
     clsql-tests clsql-uffi)
    PARASITES NIL) */
