/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clsql-postgresql-socket";
  version = "clsql-20210228-git";

  description = "Common Lisp SQL PostgreSQL Socket Driver";

  deps = [ args."clsql" args."md5" args."uffi" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz";
    sha256 = "0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4";
  };

  packageName = "clsql-postgresql-socket";

  asdFilesToKeep = ["clsql-postgresql-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-postgresql-socket DESCRIPTION
    Common Lisp SQL PostgreSQL Socket Driver SHA256
    0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4 URL
    http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz
    MD5 d32b2b37e4211f5da61d2e29847a2f12 NAME clsql-postgresql-socket FILENAME
    clsql-postgresql-socket DEPS
    ((NAME clsql FILENAME clsql) (NAME md5 FILENAME md5)
     (NAME uffi FILENAME uffi))
    DEPENDENCIES (clsql md5 uffi) VERSION clsql-20210228-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket3
     clsql-postgresql clsql-sqlite clsql-sqlite3 clsql-tests clsql-uffi clsql)
    PARASITES NIL) */
