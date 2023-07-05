/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cxml-stp";
  version = "20200325-git";

  parasites = [ "cxml-stp/test" ];

  description = "System lacks description";

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."cxml_slash_test" args."parse-number" args."puri" args."rt" args."trivial-features" args."trivial-gray-streams" args."xpath" args."xpath_slash_test" args."yacc" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cxml-stp/2020-03-25/cxml-stp-20200325-git.tgz";
    sha256 = "1y26bksmysvxifqx4lslpbsdvmcqkf7di36a3yyqnjgrb5r0jv1n";
  };

  packageName = "cxml-stp";

  asdFilesToKeep = ["cxml-stp.asd"];
  overrides = x: x;
}
/* (SYSTEM cxml-stp DESCRIPTION System lacks description SHA256
    1y26bksmysvxifqx4lslpbsdvmcqkf7di36a3yyqnjgrb5r0jv1n URL
    http://beta.quicklisp.org/archive/cxml-stp/2020-03-25/cxml-stp-20200325-git.tgz
    MD5 5622b4aae55e448473f1ba14fa3a5f4c NAME cxml-stp FILENAME cxml-stp DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME cxml/test FILENAME cxml_slash_test)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME rt FILENAME rt) (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME xpath FILENAME xpath) (NAME xpath/test FILENAME xpath_slash_test)
     (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel cl-ppcre closure-common cxml cxml/test parse-number puri
     rt trivial-features trivial-gray-streams xpath xpath/test yacc)
    VERSION 20200325-git SIBLINGS NIL PARASITES (cxml-stp/test)) */
