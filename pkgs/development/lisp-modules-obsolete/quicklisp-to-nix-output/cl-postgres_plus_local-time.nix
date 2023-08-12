/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-postgres_plus_local-time";
  version = "local-time-20210124-git";

  description = "Integration between cl-postgres and local-time";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-postgres" args."cl-ppcre" args."ironclad" args."local-time" args."md5" args."split-sequence" args."uax-15" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/local-time/2021-01-24/local-time-20210124-git.tgz";
    sha256 = "0bz5z0rd8gfd22bpqkalaijxlrk806zc010cvgd4qjapbrxzjg3s";
  };

  packageName = "cl-postgres+local-time";

  asdFilesToKeep = ["cl-postgres+local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres+local-time DESCRIPTION
    Integration between cl-postgres and local-time SHA256
    0bz5z0rd8gfd22bpqkalaijxlrk806zc010cvgd4qjapbrxzjg3s URL
    http://beta.quicklisp.org/archive/local-time/2021-01-24/local-time-20210124-git.tgz
    MD5 631d67bc84ae838792717b256f2cdbaf NAME cl-postgres+local-time FILENAME
    cl-postgres_plus_local-time DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-postgres FILENAME cl-postgres) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME ironclad FILENAME ironclad) (NAME local-time FILENAME local-time)
     (NAME md5 FILENAME md5) (NAME split-sequence FILENAME split-sequence)
     (NAME uax-15 FILENAME uax-15) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-postgres cl-ppcre ironclad
     local-time md5 split-sequence uax-15 usocket)
    VERSION local-time-20210124-git SIBLINGS (local-time) PARASITES NIL) */
