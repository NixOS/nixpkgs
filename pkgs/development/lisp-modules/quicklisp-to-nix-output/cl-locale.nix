/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-locale";
  version = "20151031-git";

  description = "Simple i18n library for Common Lisp";

  deps = [ args."alexandria" args."anaphora" args."arnesi" args."cl-annot" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."collectors" args."iterate" args."named-readtables" args."symbol-munger" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-locale/2015-10-31/cl-locale-20151031-git.tgz";
    sha256 = "14j4xazrx2v5cj4q4irfwra0ksvl2l0s7073fimpwc0xqjfsnjpg";
  };

  packageName = "cl-locale";

  asdFilesToKeep = ["cl-locale.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-locale DESCRIPTION Simple i18n library for Common Lisp SHA256
    14j4xazrx2v5cj4q4irfwra0ksvl2l0s7073fimpwc0xqjfsnjpg URL
    http://beta.quicklisp.org/archive/cl-locale/2015-10-31/cl-locale-20151031-git.tgz
    MD5 7a8fb3678938af6dc5c9fd6431428aff NAME cl-locale FILENAME cl-locale DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME arnesi FILENAME arnesi) (NAME cl-annot FILENAME cl-annot)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors) (NAME iterate FILENAME iterate)
     (NAME named-readtables FILENAME named-readtables)
     (NAME symbol-munger FILENAME symbol-munger)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria anaphora arnesi cl-annot cl-syntax cl-syntax-annot closer-mop
     collectors iterate named-readtables symbol-munger trivial-types)
    VERSION 20151031-git SIBLINGS (cl-locale-syntax cl-locale-test) PARASITES
    NIL) */
