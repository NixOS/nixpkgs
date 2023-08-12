/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "css-selectors-stp";
  version = "css-selectors-20160628-git";

  description = "An implementation of css selectors that interacts with cxml-stp";

  deps = [ args."alexandria" args."babel" args."buildnode" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."closure-common" args."closure-html" args."collectors" args."css-selectors" args."cxml" args."cxml-stp" args."flexi-streams" args."iterate" args."named-readtables" args."parse-number" args."puri" args."split-sequence" args."swank" args."symbol-munger" args."trivial-features" args."trivial-gray-streams" args."xpath" args."yacc" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/css-selectors/2016-06-28/css-selectors-20160628-git.tgz";
    sha256 = "0y9q719w5cv4g7in731q5p98n7pznb05vr7i7wi92mmpah2g1w4b";
  };

  packageName = "css-selectors-stp";

  asdFilesToKeep = ["css-selectors-stp.asd"];
  overrides = x: x;
}
/* (SYSTEM css-selectors-stp DESCRIPTION
    An implementation of css selectors that interacts with cxml-stp SHA256
    0y9q719w5cv4g7in731q5p98n7pznb05vr7i7wi92mmpah2g1w4b URL
    http://beta.quicklisp.org/archive/css-selectors/2016-06-28/css-selectors-20160628-git.tgz
    MD5 28537144b89af4ebe28c2eb365d5569f NAME css-selectors-stp FILENAME
    css-selectors-stp DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME buildnode FILENAME buildnode)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop)
     (NAME closure-common FILENAME closure-common)
     (NAME closure-html FILENAME closure-html)
     (NAME collectors FILENAME collectors)
     (NAME css-selectors FILENAME css-selectors) (NAME cxml FILENAME cxml)
     (NAME cxml-stp FILENAME cxml-stp)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate)
     (NAME named-readtables FILENAME named-readtables)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME split-sequence FILENAME split-sequence) (NAME swank FILENAME swank)
     (NAME symbol-munger FILENAME symbol-munger)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME xpath FILENAME xpath) (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel buildnode cl-interpol cl-ppcre cl-unicode closer-mop
     closure-common closure-html collectors css-selectors cxml cxml-stp
     flexi-streams iterate named-readtables parse-number puri split-sequence
     swank symbol-munger trivial-features trivial-gray-streams xpath yacc)
    VERSION css-selectors-20160628-git SIBLINGS
    (css-selectors-simple-tree css-selectors) PARASITES NIL) */
