args @ { fetchurl, ... }:
rec {
  baseName = ''clsql-postgresql-socket'';
  version = ''clsql-20201016-git'';

  description = ''Common Lisp SQL PostgreSQL Socket Driver'';

  deps = [ args."clsql" args."md5" args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz'';
    sha256 = ''0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8'';
  };

  packageName = "clsql-postgresql-socket";

  asdFilesToKeep = ["clsql-postgresql-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-postgresql-socket DESCRIPTION
    Common Lisp SQL PostgreSQL Socket Driver SHA256
    0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8 URL
    http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz
    MD5 bfa0842f9875113aed8e82eca58dab9e NAME clsql-postgresql-socket FILENAME
    clsql-postgresql-socket DEPS
    ((NAME clsql FILENAME clsql) (NAME md5 FILENAME md5)
     (NAME uffi FILENAME uffi))
    DEPENDENCIES (clsql md5 uffi) VERSION clsql-20201016-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket3
     clsql-postgresql clsql-sqlite clsql-sqlite3 clsql-tests clsql-uffi clsql)
    PARASITES NIL) */
