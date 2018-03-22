args @ { fetchurl, ... }:
rec {
  baseName = ''dbi'';
  version = ''cl-20180131-git'';

  description = ''Database independent interface for Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-annot" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."named-readtables" args."split-sequence" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2018-01-31/cl-dbi-20180131-git.tgz'';
    sha256 = ''0hz5na9aqfi3z78yhzz4dhf2zy3h0v639w41w8b1adffyqqf1vhn'';
  };

  packageName = "dbi";

  asdFilesToKeep = ["dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM dbi DESCRIPTION Database independent interface for Common Lisp
    SHA256 0hz5na9aqfi3z78yhzz4dhf2zy3h0v639w41w8b1adffyqqf1vhn URL
    http://beta.quicklisp.org/archive/cl-dbi/2018-01-31/cl-dbi-20180131-git.tgz
    MD5 7dacf1c276fab38b952813795ff1f707 NAME dbi FILENAME dbi DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME closer-mop FILENAME closer-mop)
     (NAME named-readtables FILENAME named-readtables)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-annot cl-syntax cl-syntax-annot closer-mop
     named-readtables split-sequence trivial-types)
    VERSION cl-20180131-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbd-sqlite3 dbi-test) PARASITES NIL) */
