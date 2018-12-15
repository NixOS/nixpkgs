args @ { fetchurl, ... }:
rec {
  baseName = ''buildnode-xhtml'';
  version = ''buildnode-20170403-git'';

  description = ''Tool for building up an xml dom of an excel spreadsheet nicely.'';

  deps = [ args."alexandria" args."babel" args."buildnode" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."closure-common" args."closure-html" args."collectors" args."cxml" args."cxml-dom" args."cxml-klacks" args."cxml-test" args."cxml-xml" args."flexi-streams" args."iterate" args."named-readtables" args."puri" args."split-sequence" args."swank" args."symbol-munger" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/buildnode/2017-04-03/buildnode-20170403-git.tgz'';
    sha256 = ''1gb3zsp4g31iscvvhvb99z0i7lfn1g3493q6sgpr46fmn2vdwwb6'';
  };

  packageName = "buildnode-xhtml";

  asdFilesToKeep = ["buildnode-xhtml.asd"];
  overrides = x: x;
}
/* (SYSTEM buildnode-xhtml DESCRIPTION
    Tool for building up an xml dom of an excel spreadsheet nicely. SHA256
    1gb3zsp4g31iscvvhvb99z0i7lfn1g3493q6sgpr46fmn2vdwwb6 URL
    http://beta.quicklisp.org/archive/buildnode/2017-04-03/buildnode-20170403-git.tgz
    MD5 b917f0d6c20489febbef0d5b954c350d NAME buildnode-xhtml FILENAME
    buildnode-xhtml DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME buildnode FILENAME buildnode)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop)
     (NAME closure-common FILENAME closure-common)
     (NAME closure-html FILENAME closure-html)
     (NAME collectors FILENAME collectors) (NAME cxml FILENAME cxml)
     (NAME cxml-dom FILENAME cxml-dom) (NAME cxml-klacks FILENAME cxml-klacks)
     (NAME cxml-test FILENAME cxml-test) (NAME cxml-xml FILENAME cxml-xml)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate)
     (NAME named-readtables FILENAME named-readtables)
     (NAME puri FILENAME puri) (NAME split-sequence FILENAME split-sequence)
     (NAME swank FILENAME swank) (NAME symbol-munger FILENAME symbol-munger)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel buildnode cl-interpol cl-ppcre cl-unicode closer-mop
     closure-common closure-html collectors cxml cxml-dom cxml-klacks cxml-test
     cxml-xml flexi-streams iterate named-readtables puri split-sequence swank
     symbol-munger trivial-features trivial-gray-streams)
    VERSION buildnode-20170403-git SIBLINGS
    (buildnode-excel buildnode-html5 buildnode-kml buildnode-xul buildnode)
    PARASITES NIL) */
