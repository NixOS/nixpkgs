/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-postgres";
  version = "postmodern-20210411-git";

  parasites = [ "cl-postgres/simple-date-tests" "cl-postgres/tests" ];

  description = "Low-level client library for PostgreSQL";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-ppcre" args."fiveam" args."ironclad" args."md5" args."simple-date" args."simple-date_slash_postgres-glue" args."split-sequence" args."uax-15" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-04-11/postmodern-20210411-git.tgz";
    sha256 = "0q8izkkddmqq5sw55chkx6jrycawgchaknik5i84vynv50zirsbw";
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 0q8izkkddmqq5sw55chkx6jrycawgchaknik5i84vynv50zirsbw URL
    http://beta.quicklisp.org/archive/postmodern/2021-04-11/postmodern-20210411-git.tgz
    MD5 8a75a05ba9e371f672f2620d40724cb2 NAME cl-postgres FILENAME cl-postgres
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME fiveam FILENAME fiveam) (NAME ironclad FILENAME ironclad)
     (NAME md5 FILENAME md5) (NAME simple-date FILENAME simple-date)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME uax-15 FILENAME uax-15) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-ppcre fiveam ironclad md5
     simple-date simple-date/postgres-glue split-sequence uax-15 usocket)
    VERSION postmodern-20210411-git SIBLINGS (postmodern s-sql simple-date)
    PARASITES (cl-postgres/simple-date-tests cl-postgres/tests)) */
