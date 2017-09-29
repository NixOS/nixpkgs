args @ { fetchurl, ... }:
rec {
  baseName = ''lisp-unit2'';
  version = ''20160531-git'';

  parasites = [ "lisp-unit2-test" ];

  description = ''Common Lisp library that supports unit testing.'';

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."symbol-munger" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lisp-unit2/2016-05-31/lisp-unit2-20160531-git.tgz'';
    sha256 = ''17frcygs515l611cwggm90xapl8xng9cylsrdh11ygmdxwwy59sv'';
  };

  packageName = "lisp-unit2";

  asdFilesToKeep = ["lisp-unit2.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-unit2 DESCRIPTION
    Common Lisp library that supports unit testing. SHA256
    17frcygs515l611cwggm90xapl8xng9cylsrdh11ygmdxwwy59sv URL
    http://beta.quicklisp.org/archive/lisp-unit2/2016-05-31/lisp-unit2-20160531-git.tgz
    MD5 913675bff1f86453887681e72ae5914d NAME lisp-unit2 FILENAME lisp-unit2
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     symbol-munger)
    VERSION 20160531-git SIBLINGS NIL PARASITES (lisp-unit2-test)) */
