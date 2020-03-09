args @ { fetchurl, ... }:
rec {
  baseName = ''clsql-postgresql'';
  version = ''clsql-20160208-git'';

  description = ''Common Lisp PostgreSQL API Driver'';

  deps = [ args."clsql" args."clsql-uffi" args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz'';
    sha256 = ''0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn'';
  };

  packageName = "clsql-postgresql";

  asdFilesToKeep = ["clsql-postgresql.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-postgresql DESCRIPTION Common Lisp PostgreSQL API Driver
    SHA256 0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn URL
    http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz
    MD5 d1da7688361337a7de4fe7452c225a06 NAME clsql-postgresql FILENAME
    clsql-postgresql DEPS
    ((NAME clsql FILENAME clsql) (NAME clsql-uffi FILENAME clsql-uffi)
     (NAME uffi FILENAME uffi))
    DEPENDENCIES (clsql clsql-uffi uffi) VERSION clsql-20160208-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-sqlite clsql-sqlite3 clsql-tests clsql-uffi
     clsql)
    PARASITES NIL) */
