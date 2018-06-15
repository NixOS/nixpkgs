args @ { fetchurl, ... }:
rec {
  baseName = ''cxml-stp'';
  version = ''20120520-git'';

  parasites = [ "cxml-stp-test" ];

  description = '''';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."cxml-dom" args."cxml-klacks" args."cxml-test" args."cxml-xml" args."parse-number" args."puri" args."rt" args."trivial-features" args."trivial-gray-streams" args."xpath" args."yacc" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cxml-stp/2012-05-20/cxml-stp-20120520-git.tgz'';
    sha256 = ''1pmh7wvkncbwwp30d445mhj21j210swq03f6hm44x1231s8r8azv'';
  };

  packageName = "cxml-stp";

  asdFilesToKeep = ["cxml-stp.asd"];
  overrides = x: x;
}
/* (SYSTEM cxml-stp DESCRIPTION NIL SHA256
    1pmh7wvkncbwwp30d445mhj21j210swq03f6hm44x1231s8r8azv URL
    http://beta.quicklisp.org/archive/cxml-stp/2012-05-20/cxml-stp-20120520-git.tgz
    MD5 7bc57586a91cd4d4864b8cbad3689d85 NAME cxml-stp FILENAME cxml-stp DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME cxml-dom FILENAME cxml-dom) (NAME cxml-klacks FILENAME cxml-klacks)
     (NAME cxml-test FILENAME cxml-test) (NAME cxml-xml FILENAME cxml-xml)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME rt FILENAME rt) (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME xpath FILENAME xpath) (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel cl-ppcre closure-common cxml cxml-dom cxml-klacks
     cxml-test cxml-xml parse-number puri rt trivial-features
     trivial-gray-streams xpath yacc)
    VERSION 20120520-git SIBLINGS NIL PARASITES (cxml-stp-test)) */
