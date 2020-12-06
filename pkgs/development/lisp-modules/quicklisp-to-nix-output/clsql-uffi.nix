args @ { fetchurl, ... }:
rec {
  baseName = ''clsql-uffi'';
  version = ''clsql-20201016-git'';

  description = ''Common UFFI Helper functions for Common Lisp SQL Interface Library'';

  deps = [ args."clsql" args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz'';
    sha256 = ''0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8'';
  };

  packageName = "clsql-uffi";

  asdFilesToKeep = ["clsql-uffi.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-uffi DESCRIPTION
    Common UFFI Helper functions for Common Lisp SQL Interface Library SHA256
    0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8 URL
    http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz
    MD5 bfa0842f9875113aed8e82eca58dab9e NAME clsql-uffi FILENAME clsql-uffi
    DEPS ((NAME clsql FILENAME clsql) (NAME uffi FILENAME uffi)) DEPENDENCIES
    (clsql uffi) VERSION clsql-20201016-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-sqlite3
     clsql-tests clsql)
    PARASITES NIL) */
