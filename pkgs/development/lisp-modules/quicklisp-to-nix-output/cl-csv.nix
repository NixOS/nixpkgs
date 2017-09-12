args @ { fetchurl, ... }:
rec {
  baseName = ''cl-csv'';
  version = ''20170403-git'';

  parasites = [ "cl-csv-test" ];

  description = ''Facilities for reading and writing CSV format files'';

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."lisp-unit2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-csv/2017-04-03/cl-csv-20170403-git.tgz'';
    sha256 = ''1mz0hr0r7yxw1dzdbaqzxabmipp286zc6aglni9f46isjwmqpy6h'';
  };

  packageName = "cl-csv";

  asdFilesToKeep = ["cl-csv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-csv DESCRIPTION
    Facilities for reading and writing CSV format files SHA256
    1mz0hr0r7yxw1dzdbaqzxabmipp286zc6aglni9f46isjwmqpy6h URL
    http://beta.quicklisp.org/archive/cl-csv/2017-04-03/cl-csv-20170403-git.tgz
    MD5 1e71a90c5057371fab044d440c39f0a3 NAME cl-csv FILENAME cl-csv DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     lisp-unit2)
    VERSION 20170403-git SIBLINGS (cl-csv-clsql cl-csv-data-table) PARASITES
    (cl-csv-test)) */
