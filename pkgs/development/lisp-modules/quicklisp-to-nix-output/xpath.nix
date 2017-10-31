args @ { fetchurl, ... }:
rec {
  baseName = ''xpath'';
  version = ''plexippus-20120909-darcs'';

  description = '''';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."cxml-dom" args."cxml-klacks" args."cxml-test" args."cxml-xml" args."parse-number" args."puri" args."trivial-features" args."trivial-gray-streams" args."yacc" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plexippus-xpath/2012-09-09/plexippus-xpath-20120909-darcs.tgz'';
    sha256 = ''1zlkr7ck60gr5rxfiq22prnbblih14ywr0s5g2kss2a842zvkxn6'';
  };

  packageName = "xpath";

  asdFilesToKeep = ["xpath.asd"];
  overrides = x: x;
}
/* (SYSTEM xpath DESCRIPTION NIL SHA256
    1zlkr7ck60gr5rxfiq22prnbblih14ywr0s5g2kss2a842zvkxn6 URL
    http://beta.quicklisp.org/archive/plexippus-xpath/2012-09-09/plexippus-xpath-20120909-darcs.tgz
    MD5 1d7457bffe7c4f6e1631c59bc00723d4 NAME xpath FILENAME xpath DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME cxml-dom FILENAME cxml-dom) (NAME cxml-klacks FILENAME cxml-klacks)
     (NAME cxml-test FILENAME cxml-test) (NAME cxml-xml FILENAME cxml-xml)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel cl-ppcre closure-common cxml cxml-dom cxml-klacks
     cxml-test cxml-xml parse-number puri trivial-features trivial-gray-streams
     yacc)
    VERSION plexippus-20120909-darcs SIBLINGS NIL PARASITES NIL) */
