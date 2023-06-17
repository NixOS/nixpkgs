/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "xml_dot_location";
  version = "20200325-git";

  parasites = [ "xml.location/test" ];

  description = "This system provides a convenient interface for
 manipulating XML data. It is inspired by the xmltio library.";

  deps = [ args."alexandria" args."anaphora" args."babel" args."cl-ppcre" args."closer-mop" args."closure-common" args."cxml" args."cxml-stp" args."iterate" args."let-plus" args."lift" args."more-conditions" args."parse-number" args."puri" args."split-sequence" args."trivial-features" args."trivial-gray-streams" args."xpath" args."yacc" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/xml.location/2020-03-25/xml.location-20200325-git.tgz";
    sha256 = "0wfccj1p1al0w9pc5rhxpsvm3wb2lr5fc4cfjyg751pwsasjikwx";
  };

  packageName = "xml.location";

  asdFilesToKeep = ["xml.location.asd"];
  overrides = x: x;
}
/* (SYSTEM xml.location DESCRIPTION
    This system provides a convenient interface for
 manipulating XML data. It is inspired by the xmltio library.
    SHA256 0wfccj1p1al0w9pc5rhxpsvm3wb2lr5fc4cfjyg751pwsasjikwx URL
    http://beta.quicklisp.org/archive/xml.location/2020-03-25/xml.location-20200325-git.tgz
    MD5 90cf4fd2450ba562c7f9657391dacb1d NAME xml.location FILENAME
    xml_dot_location DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME babel FILENAME babel) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closer-mop FILENAME closer-mop)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME cxml-stp FILENAME cxml-stp) (NAME iterate FILENAME iterate)
     (NAME let-plus FILENAME let-plus) (NAME lift FILENAME lift)
     (NAME more-conditions FILENAME more-conditions)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME xpath FILENAME xpath) (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria anaphora babel cl-ppcre closer-mop closure-common cxml cxml-stp
     iterate let-plus lift more-conditions parse-number puri split-sequence
     trivial-features trivial-gray-streams xpath yacc)
    VERSION 20200325-git SIBLINGS (xml.location-and-local-time) PARASITES
    (xml.location/test)) */
