args @ { fetchurl, ... }:
rec {
  baseName = ''dbi'';
  version = ''cl-20180831-git'';

  description = ''Database independent interface for Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-annot" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."named-readtables" args."split-sequence" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2018-08-31/cl-dbi-20180831-git.tgz'';
    sha256 = ''19cpzdzjjzm0if77dycsk8lj91ihwr51mbjmf3fx0wqwr8k5y0g9'';
  };

  packageName = "dbi";

  asdFilesToKeep = ["dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM dbi DESCRIPTION Database independent interface for Common Lisp
    SHA256 19cpzdzjjzm0if77dycsk8lj91ihwr51mbjmf3fx0wqwr8k5y0g9 URL
    http://beta.quicklisp.org/archive/cl-dbi/2018-08-31/cl-dbi-20180831-git.tgz
    MD5 2fc95bff95d3cd25e3afeb003ee009d2 NAME dbi FILENAME dbi DEPS
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
    VERSION cl-20180831-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbd-sqlite3 dbi-test) PARASITES NIL) */
