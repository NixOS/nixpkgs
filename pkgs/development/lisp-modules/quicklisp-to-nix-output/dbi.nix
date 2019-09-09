args @ { fetchurl, ... }:
{
  baseName = ''dbi'';
  version = ''cl-20190521-git'';

  description = ''Database independent interface for Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-annot" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."named-readtables" args."split-sequence" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2019-05-21/cl-dbi-20190521-git.tgz'';
    sha256 = ''1q0hhgxnd91v020zh9ivlmzhzz5ald6q1bm5i5cawzh0xfyfhhvg'';
  };

  packageName = "dbi";

  asdFilesToKeep = ["dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM dbi DESCRIPTION Database independent interface for Common Lisp
    SHA256 1q0hhgxnd91v020zh9ivlmzhzz5ald6q1bm5i5cawzh0xfyfhhvg URL
    http://beta.quicklisp.org/archive/cl-dbi/2019-05-21/cl-dbi-20190521-git.tgz
    MD5 ba77d3a955991b406f56cc1a09e71dc2 NAME dbi FILENAME dbi DEPS
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
    VERSION cl-20190521-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbd-sqlite3 dbi-test) PARASITES NIL) */
