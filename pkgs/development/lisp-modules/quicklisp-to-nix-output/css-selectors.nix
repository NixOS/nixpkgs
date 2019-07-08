args @ { fetchurl, ... }:
rec {
  baseName = ''css-selectors'';
  version = ''20160628-git'';

  parasites = [ "css-selectors-test" ];

  description = ''An implementation of css selectors'';

  deps = [ args."alexandria" args."babel" args."buildnode" args."buildnode-xhtml" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."closure-common" args."closure-html" args."collectors" args."cxml" args."flexi-streams" args."iterate" args."lisp-unit2" args."named-readtables" args."puri" args."split-sequence" args."swank" args."symbol-munger" args."trivial-features" args."trivial-gray-streams" args."yacc" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/css-selectors/2016-06-28/css-selectors-20160628-git.tgz'';
    sha256 = ''0y9q719w5cv4g7in731q5p98n7pznb05vr7i7wi92mmpah2g1w4b'';
  };

  packageName = "css-selectors";

  asdFilesToKeep = ["css-selectors.asd"];
  overrides = x: x;
}
/* (SYSTEM css-selectors DESCRIPTION An implementation of css selectors SHA256
    0y9q719w5cv4g7in731q5p98n7pznb05vr7i7wi92mmpah2g1w4b URL
    http://beta.quicklisp.org/archive/css-selectors/2016-06-28/css-selectors-20160628-git.tgz
    MD5 28537144b89af4ebe28c2eb365d5569f NAME css-selectors FILENAME
    css-selectors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME buildnode FILENAME buildnode)
     (NAME buildnode-xhtml FILENAME buildnode-xhtml)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop)
     (NAME closure-common FILENAME closure-common)
     (NAME closure-html FILENAME closure-html)
     (NAME collectors FILENAME collectors) (NAME cxml FILENAME cxml)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2)
     (NAME named-readtables FILENAME named-readtables)
     (NAME puri FILENAME puri) (NAME split-sequence FILENAME split-sequence)
     (NAME swank FILENAME swank) (NAME symbol-munger FILENAME symbol-munger)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel buildnode buildnode-xhtml cl-interpol cl-ppcre cl-unicode
     closer-mop closure-common closure-html collectors cxml flexi-streams
     iterate lisp-unit2 named-readtables puri split-sequence swank
     symbol-munger trivial-features trivial-gray-streams yacc)
    VERSION 20160628-git SIBLINGS (css-selectors-simple-tree css-selectors-stp)
    PARASITES (css-selectors-test)) */
