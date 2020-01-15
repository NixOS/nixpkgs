args @ { fetchurl, ... }:
{
  baseName = ''clsql-postgresql-socket'';
  version = ''clsql-20160208-git'';

  description = ''Common Lisp SQL PostgreSQL Socket Driver'';

  deps = [ args."clsql" args."md5" args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz'';
    sha256 = ''0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn'';
  };

  packageName = "clsql-postgresql-socket";

  asdFilesToKeep = ["clsql-postgresql-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-postgresql-socket DESCRIPTION
    Common Lisp SQL PostgreSQL Socket Driver SHA256
    0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn URL
    http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz
    MD5 d1da7688361337a7de4fe7452c225a06 NAME clsql-postgresql-socket FILENAME
    clsql-postgresql-socket DEPS
    ((NAME clsql FILENAME clsql) (NAME md5 FILENAME md5)
     (NAME uffi FILENAME uffi))
    DEPENDENCIES (clsql md5 uffi) VERSION clsql-20160208-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket3
     clsql-postgresql clsql-sqlite clsql-sqlite3 clsql-tests clsql-uffi clsql)
    PARASITES NIL) */
