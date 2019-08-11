args @ { fetchurl, ... }:
rec {
  baseName = ''xpath'';
  version = ''plexippus-20181210-git'';

  parasites = [ "xpath/test" ];

  description = ''An implementation of the XML Path Language (XPath) Version 1.0'';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."parse-number" args."puri" args."trivial-features" args."trivial-gray-streams" args."yacc" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plexippus-xpath/2018-12-10/plexippus-xpath-20181210-git.tgz'';
    sha256 = ''1acg17ckl65h0xr1vv2ljkmli7jgln7qhl4zs8lwl9jcayi6fynn'';
  };

  packageName = "xpath";

  asdFilesToKeep = ["xpath.asd"];
  overrides = x: x;
}
/* (SYSTEM xpath DESCRIPTION
    An implementation of the XML Path Language (XPath) Version 1.0 SHA256
    1acg17ckl65h0xr1vv2ljkmli7jgln7qhl4zs8lwl9jcayi6fynn URL
    http://beta.quicklisp.org/archive/plexippus-xpath/2018-12-10/plexippus-xpath-20181210-git.tgz
    MD5 106060a6e90dd35c80385ad5a1e8554d NAME xpath FILENAME xpath DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel cl-ppcre closure-common cxml parse-number puri
     trivial-features trivial-gray-streams yacc)
    VERSION plexippus-20181210-git SIBLINGS NIL PARASITES (xpath/test)) */
