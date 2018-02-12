args @ { fetchurl, ... }:
rec {
  baseName = ''cl-csv'';
  version = ''20180131-git'';

  parasites = [ "cl-csv/test" ];

  description = ''Facilities for reading and writing CSV format files'';

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."lisp-unit2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-csv/2018-01-31/cl-csv-20180131-git.tgz'';
    sha256 = ''0i912ch1mvms5iynmxrlxclzc325n3zsn3y9qdszh5lhpmw043wh'';
  };

  packageName = "cl-csv";

  asdFilesToKeep = ["cl-csv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-csv DESCRIPTION
    Facilities for reading and writing CSV format files SHA256
    0i912ch1mvms5iynmxrlxclzc325n3zsn3y9qdszh5lhpmw043wh URL
    http://beta.quicklisp.org/archive/cl-csv/2018-01-31/cl-csv-20180131-git.tgz
    MD5 0be8956ee31e03436f8a2190387bad46 NAME cl-csv FILENAME cl-csv DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     lisp-unit2)
    VERSION 20180131-git SIBLINGS (cl-csv-clsql cl-csv-data-table) PARASITES
    (cl-csv/test)) */
