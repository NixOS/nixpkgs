args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-postgres'';
  version = ''cl-dbi-20180430-git'';

  description = ''Database driver for PostgreSQL.'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-annot" args."cl-postgres" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."dbi" args."md5" args."named-readtables" args."split-sequence" args."trivial-garbage" args."trivial-types" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2018-04-30/cl-dbi-20180430-git.tgz'';
    sha256 = ''0bjkba9z93h2sf9n40dvmw1p6nq2p3d5zw9w3zw9k1crn7a601sv'';
  };

  packageName = "dbd-postgres";

  asdFilesToKeep = ["dbd-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM dbd-postgres DESCRIPTION Database driver for PostgreSQL. SHA256
    0bjkba9z93h2sf9n40dvmw1p6nq2p3d5zw9w3zw9k1crn7a601sv URL
    http://beta.quicklisp.org/archive/cl-dbi/2018-04-30/cl-dbi-20180430-git.tgz
    MD5 1bc845e8738c4987342cb0f56200ba50 NAME dbd-postgres FILENAME
    dbd-postgres DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME md5 FILENAME md5) (NAME named-readtables FILENAME named-readtables)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-types FILENAME trivial-types)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-annot cl-postgres cl-syntax cl-syntax-annot
     closer-mop dbi md5 named-readtables split-sequence trivial-garbage
     trivial-types usocket)
    VERSION cl-dbi-20180430-git SIBLINGS
    (cl-dbi dbd-mysql dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
