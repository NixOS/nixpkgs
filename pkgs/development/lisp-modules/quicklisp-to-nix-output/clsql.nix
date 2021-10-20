/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clsql";
  version = "20210228-git";

  description = "Common Lisp SQL Interface library";

  deps = [ args."uffi" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz";
    sha256 = "0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4";
  };

  packageName = "clsql";

  asdFilesToKeep = ["clsql.asd"];
  overrides = x: x;
}
/* (SYSTEM clsql DESCRIPTION Common Lisp SQL Interface library SHA256
    0g7racshjy47xbfijymddjwnphp0c93z2lnlgi330g257s9l7vd4 URL
    http://beta.quicklisp.org/archive/clsql/2021-02-28/clsql-20210228-git.tgz
    MD5 d32b2b37e4211f5da61d2e29847a2f12 NAME clsql FILENAME clsql DEPS
    ((NAME uffi FILENAME uffi)) DEPENDENCIES (uffi) VERSION 20210228-git
    SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket
     clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-sqlite3
     clsql-tests clsql-uffi)
    PARASITES NIL) */
