/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clsql-sqlite3";
  version = "clsql-20210228-git";

  description = "Common Lisp Sqlite3 Driver";

  deps = [ args."clsql" args."clsql-uffi" args."uffi" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz";
    sha256 = "0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4";
  };

  packageName = "clsql-sqlite3";

  asdFilesToKeep = ["clsql-sqlite3.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-sqlite3 DESCRIPTION Common Lisp Sqlite3 Driver SHA256
    0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4 URL
    http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz
    MD5 d32b2b37e4211f5da61d2e29847a2f12 NAME clsql-sqlite3 FILENAME
    clsql-sqlite3 DEPS
    ((NAME clsql FILENAME clsql) (NAME clsql-uffi FILENAME clsql-uffi)
     (NAME uffi FILENAME uffi))
    DEPENDENCIES (clsql clsql-uffi uffi) VERSION clsql-20210228-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-tests
     clsql-uffi clsql)
    PARASITES NIL) */
