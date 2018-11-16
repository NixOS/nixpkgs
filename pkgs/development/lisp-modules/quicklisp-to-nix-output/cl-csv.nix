args @ { fetchurl, ... }:
rec {
  baseName = ''cl-csv'';
  version = ''20180831-git'';

  parasites = [ "cl-csv/speed-test" "cl-csv/test" ];

  description = ''Facilities for reading and writing CSV format files'';

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."lisp-unit2" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-csv/2018-08-31/cl-csv-20180831-git.tgz'';
    sha256 = ''0cy2pnzm3c6hmimp0kl5nz03rw6nzgy37i1ifpg9grmd3wipm9fd'';
  };

  packageName = "cl-csv";

  asdFilesToKeep = ["cl-csv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-csv DESCRIPTION
    Facilities for reading and writing CSV format files SHA256
    0cy2pnzm3c6hmimp0kl5nz03rw6nzgy37i1ifpg9grmd3wipm9fd URL
    http://beta.quicklisp.org/archive/cl-csv/2018-08-31/cl-csv-20180831-git.tgz
    MD5 4bd0ef366dea9d48c4581ed73a208cf3 NAME cl-csv FILENAME cl-csv DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     lisp-unit2 named-readtables)
    VERSION 20180831-git SIBLINGS (cl-csv-clsql cl-csv-data-table) PARASITES
    (cl-csv/speed-test cl-csv/test)) */
