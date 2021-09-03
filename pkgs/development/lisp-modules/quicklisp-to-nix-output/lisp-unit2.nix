/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lisp-unit2";
  version = "20180131-git";

  parasites = [ "lisp-unit2-test" ];

  description = "Common Lisp library that supports unit testing.";

  deps = [ args."alexandria" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."iterate" args."named-readtables" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lisp-unit2/2018-01-31/lisp-unit2-20180131-git.tgz";
    sha256 = "04kwrg605mqzf3ghshgbygvvryk5kipl6gyc5kdaxafjxvhxaak7";
  };

  packageName = "lisp-unit2";

  asdFilesToKeep = ["lisp-unit2.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-unit2 DESCRIPTION
    Common Lisp library that supports unit testing. SHA256
    04kwrg605mqzf3ghshgbygvvryk5kipl6gyc5kdaxafjxvhxaak7 URL
    http://beta.quicklisp.org/archive/lisp-unit2/2018-01-31/lisp-unit2-20180131-git.tgz
    MD5 d061fa640837441a5d2eecbefd8b2e69 NAME lisp-unit2 FILENAME lisp-unit2
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate)
     (NAME named-readtables FILENAME named-readtables)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (alexandria cl-interpol cl-ppcre cl-unicode flexi-streams iterate
     named-readtables symbol-munger)
    VERSION 20180131-git SIBLINGS NIL PARASITES (lisp-unit2-test)) */
