/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clsql-uffi";
  version = "clsql-20210228-git";

  description = "Common UFFI Helper functions for Common Lisp SQL Interface Library";

  deps = [ args."clsql" args."uffi" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz";
    sha256 = "0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4";
  };

  packageName = "clsql-uffi";

  asdFilesToKeep = ["clsql-uffi.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql-uffi DESCRIPTION
    Common UFFI Helper functions for Common Lisp SQL Interface Library SHA256
    0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4 URL
    http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz
    MD5 d32b2b37e4211f5da61d2e29847a2f12 NAME clsql-uffi FILENAME clsql-uffi
    DEPS ((NAME clsql FILENAME clsql) (NAME uffi FILENAME uffi)) DEPENDENCIES
    (clsql uffi) VERSION clsql-20210228-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-sqlite3
     clsql-tests clsql)
    PARASITES NIL) */
