args @ { fetchurl, ... }:
rec {
  baseName = ''dbi'';
  version = ''cl-20170725-git'';

  description = ''Database independent interface for Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-annot" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."named-readtables" args."split-sequence" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2017-07-25/cl-dbi-20170725-git.tgz'';
    sha256 = ''1gmd5y44nidqmxw7zk0mxl4mgl3mcjf1v05gjdslp3ginzznrqzl'';
  };

  packageName = "dbi";

  asdFilesToKeep = ["dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM dbi DESCRIPTION Database independent interface for Common Lisp
    SHA256 1gmd5y44nidqmxw7zk0mxl4mgl3mcjf1v05gjdslp3ginzznrqzl URL
    http://beta.quicklisp.org/archive/cl-dbi/2017-07-25/cl-dbi-20170725-git.tgz
    MD5 a9fe67b7fea2640cea9708342a1347bd NAME dbi FILENAME dbi DEPS
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
    VERSION cl-20170725-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbd-sqlite3 dbi-test) PARASITES NIL) */
