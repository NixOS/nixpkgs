args @ { fetchurl, ... }:
{
  baseName = ''cxml-stp'';
  version = ''20190521-git'';

  parasites = [ "cxml-stp/test" ];

  description = ''System lacks description'';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."parse-number" args."puri" args."rt" args."trivial-features" args."trivial-gray-streams" args."xpath" args."xpath_slash_test" args."yacc" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cxml-stp/2019-05-21/cxml-stp-20190521-git.tgz'';
    sha256 = ''1lgqw1w65yra0lyy41finj19y1z6yqkvkyzgvagb7s54cnzafz21'';
  };

  packageName = "cxml-stp";

  asdFilesToKeep = ["cxml-stp.asd"];
  overrides = x: x;
}
/* (SYSTEM cxml-stp DESCRIPTION System lacks description SHA256
    1lgqw1w65yra0lyy41finj19y1z6yqkvkyzgvagb7s54cnzafz21 URL
    http://beta.quicklisp.org/archive/cxml-stp/2019-05-21/cxml-stp-20190521-git.tgz
    MD5 9e0c99bd2b547e07b23305a5ff72aff6 NAME cxml-stp FILENAME cxml-stp DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME rt FILENAME rt) (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME xpath FILENAME xpath) (NAME xpath/test FILENAME xpath_slash_test)
     (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel cl-ppcre closure-common cxml parse-number puri rt
     trivial-features trivial-gray-streams xpath xpath/test yacc)
    VERSION 20190521-git SIBLINGS NIL PARASITES (cxml-stp/test)) */
