args @ { fetchurl, ... }:
rec {
  baseName = ''clsql-sqlite3'';
  version = ''clsql-20201016-git'';

  description = ''Common Lisp Sqlite3 Driver'';

  deps = [ args."clsql" args."clsql-uffi" args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz'';
    sha256 = ''0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8'';
  };

  packageName = "clsql-sqlite3";

  asdFilesToKeep = ["clsql-sqlite3.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-sqlite3 DESCRIPTION Common Lisp Sqlite3 Driver SHA256
    0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8 URL
    http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz
    MD5 bfa0842f9875113aed8e82eca58dab9e NAME clsql-sqlite3 FILENAME
    clsql-sqlite3 DEPS
    ((NAME clsql FILENAME clsql) (NAME clsql-uffi FILENAME clsql-uffi)
     (NAME uffi FILENAME uffi))
    DEPENDENCIES (clsql clsql-uffi uffi) VERSION clsql-20201016-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-tests
     clsql-uffi clsql)
    PARASITES NIL) */
