/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "data-table";
  version = "20160208-git";

  parasites = [ "data-table-test" ];

  description = "A library providing a data-table class, and useful functionality around this";

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."lisp-unit2" args."named-readtables" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/data-table/2016-02-08/data-table-20160208-git.tgz";
    sha256 = "0xzjk3jxx11ziw5348ddalygi84wwwcjcxmqvm5rscgzh012h8gm";
  };

  packageName = "data-table";

  asdFilesToKeep = ["data-table.asd"];
  overrides = x: x;
}
/* (SYSTEM data-table DESCRIPTION
    A library providing a data-table class, and useful functionality around this
    SHA256 0xzjk3jxx11ziw5348ddalygi84wwwcjcxmqvm5rscgzh012h8gm URL
    http://beta.quicklisp.org/archive/data-table/2016-02-08/data-table-20160208-git.tgz
    MD5 0507150b0fcfdab96e0ef7668d31113c NAME data-table FILENAME data-table
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2)
     (NAME named-readtables FILENAME named-readtables)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     lisp-unit2 named-readtables symbol-munger)
    VERSION 20160208-git SIBLINGS (data-table-clsql) PARASITES
    (data-table-test)) */
