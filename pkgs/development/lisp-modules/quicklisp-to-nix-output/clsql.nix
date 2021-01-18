args @ { fetchurl, ... }:
rec {
  baseName = ''clsql'';
  version = ''20201016-git'';

  description = ''Common Lisp SQL Interface library'';

  deps = [ args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz'';
    sha256 = ''0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8'';
  };

  packageName = "clsql";

  asdFilesToKeep = ["clsql.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql DESCRIPTION Common Lisp SQL Interface library SHA256
    0wzjxcm7df4fipvj5qsqlllai92hkzd4cvlaghvaikcah9r63hv8 URL
    http://beta.quicklisp.org/archive/clsql/2020-10-16/clsql-20201016-git.tgz
    MD5 bfa0842f9875113aed8e82eca58dab9e NAME clsql FILENAME clsql DEPS
    ((NAME uffi FILENAME uffi)) DEPENDENCIES (uffi) VERSION 20201016-git
    SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-sqlite3
     clsql-tests clsql-uffi)
    PARASITES NIL) */
