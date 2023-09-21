/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-csv";
  version = "20201016-git";

  parasites = [ "cl-csv/speed-test" "cl-csv/test" ];

  description = "Facilities for reading and writing CSV format files";

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."lisp-unit2" args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-csv/2020-10-16/cl-csv-20201016-git.tgz";
    sha256 = "1w12ads26v5sgcmy6rjm6ys9lml7l6rz86w776s2an2maci9kzmf";
  };

  packageName = "cl-csv";

  asdFilesToKeep = ["cl-csv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-csv DESCRIPTION
    Facilities for reading and writing CSV format files SHA256
    1w12ads26v5sgcmy6rjm6ys9lml7l6rz86w776s2an2maci9kzmf URL
    http://beta.quicklisp.org/archive/cl-csv/2020-10-16/cl-csv-20201016-git.tgz
    MD5 3e067784236ab620857fe738dafedb4b NAME cl-csv FILENAME cl-csv DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     lisp-unit2 named-readtables)
    VERSION 20201016-git SIBLINGS (cl-csv-clsql cl-csv-data-table) PARASITES
    (cl-csv/speed-test cl-csv/test)) */
