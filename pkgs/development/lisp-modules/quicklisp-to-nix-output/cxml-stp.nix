args @ { fetchurl, ... }:
rec {
  baseName = ''cxml-stp'';
  version = ''20181018-git'';

  parasites = [ "cxml-stp-test" ];

  description = '''';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."parse-number" args."puri" args."rt" args."trivial-features" args."trivial-gray-streams" args."xpath" args."xpath_slash_test" args."yacc" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cxml-stp/2018-10-18/cxml-stp-20181018-git.tgz'';
    sha256 = ''0xv6drasndp802mgww53n6hpf0qjh2r7d48rld1qibf20y80bz77'';
  };

  packageName = "cxml-stp";

  asdFilesToKeep = ["cxml-stp.asd"];
  overrides = x: x;
}
/* (SYSTEM cxml-stp DESCRIPTION NIL SHA256
    0xv6drasndp802mgww53n6hpf0qjh2r7d48rld1qibf20y80bz77 URL
    http://beta.quicklisp.org/archive/cxml-stp/2018-10-18/cxml-stp-20181018-git.tgz
    MD5 38d39fce85b270145d5a5bd4668d953f NAME cxml-stp FILENAME cxml-stp DEPS
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
    VERSION 20181018-git SIBLINGS NIL PARASITES (cxml-stp-test)) */
