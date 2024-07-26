/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lisp-stat";
  version = "20210411-git";

  parasites = [ "lisp-stat/rdata" ];

  description = "A statistical computing environment for Common Lisp";

  deps = [ args."alexandria" args."anaphora" args."array-operations" args."cl-ascii-table" args."cl-csv" args."cl-interpol" args."cl-ppcre" args."cl-semver" args."cl-unicode" args."data-frame" args."dexador" args."dfio" args."esrap" args."flexi-streams" args."iterate" args."let-plus" args."make-hash" args."named-readtables" args."num-utils" args."select" args."split-sequence" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lisp-stat/2021-04-11/lisp-stat-20210411-git.tgz";
    sha256 = "110cfj1svn9m9xn6l8p5z88knp0idyf0zcbnwi9rrgxssvaiwncg";
  };

  packageName = "lisp-stat";

  asdFilesToKeep = ["lisp-stat.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-stat DESCRIPTION
    A statistical computing environment for Common Lisp SHA256
    110cfj1svn9m9xn6l8p5z88knp0idyf0zcbnwi9rrgxssvaiwncg URL
    http://beta.quicklisp.org/archive/lisp-stat/2021-04-11/lisp-stat-20210411-git.tgz
    MD5 766777ed3ba44a0835fc02c5b1f13970 NAME lisp-stat FILENAME lisp-stat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME array-operations FILENAME array-operations)
     (NAME cl-ascii-table FILENAME cl-ascii-table)
     (NAME cl-csv FILENAME cl-csv) (NAME cl-interpol FILENAME cl-interpol)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-semver FILENAME cl-semver)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME data-frame FILENAME data-frame) (NAME dexador FILENAME dexador)
     (NAME dfio FILENAME dfio) (NAME esrap FILENAME esrap)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME let-plus FILENAME let-plus)
     (NAME make-hash FILENAME make-hash)
     (NAME named-readtables FILENAME named-readtables)
     (NAME num-utils FILENAME num-utils) (NAME select FILENAME select)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (alexandria anaphora array-operations cl-ascii-table cl-csv cl-interpol
     cl-ppcre cl-semver cl-unicode data-frame dexador dfio esrap flexi-streams
     iterate let-plus make-hash named-readtables num-utils select
     split-sequence trivial-with-current-source-form)
    VERSION 20210411-git SIBLINGS NIL PARASITES (lisp-stat/rdata)) */
