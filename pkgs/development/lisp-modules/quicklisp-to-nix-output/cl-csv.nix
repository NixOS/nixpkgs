args @ { fetchurl, ... }:
rec {
  baseName = ''cl-csv'';
  version = ''20180228-git'';

  parasites = [ "cl-csv/speed-test" "cl-csv/test" ];

  description = ''Facilities for reading and writing CSV format files'';

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."lisp-unit2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-csv/2018-02-28/cl-csv-20180228-git.tgz'';
    sha256 = ''1xfdiyxj793inrlfqi1yi9sf6p29mg9h7qqhnjk94masmx5zq93r'';
  };

  packageName = "cl-csv";

  asdFilesToKeep = ["cl-csv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-csv DESCRIPTION
    Facilities for reading and writing CSV format files SHA256
    1xfdiyxj793inrlfqi1yi9sf6p29mg9h7qqhnjk94masmx5zq93r URL
    http://beta.quicklisp.org/archive/cl-csv/2018-02-28/cl-csv-20180228-git.tgz
    MD5 be174a4d7cc2ea24418df63757daed94 NAME cl-csv FILENAME cl-csv DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     lisp-unit2)
    VERSION 20180228-git SIBLINGS (cl-csv-clsql cl-csv-data-table) PARASITES
    (cl-csv/speed-test cl-csv/test)) */
