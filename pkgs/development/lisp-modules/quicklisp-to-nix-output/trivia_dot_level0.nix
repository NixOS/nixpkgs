args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_level0'';
  version = ''trivia-20200925-git'';

  description = ''Bootstrapping Pattern Matching Library for implementing Trivia'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz'';
    sha256 = ''192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z'';
  };

  packageName = "trivia.level0";

  asdFilesToKeep = ["trivia.level0.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level0 DESCRIPTION
    Bootstrapping Pattern Matching Library for implementing Trivia SHA256
    192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z URL
    http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz
    MD5 c6546ecf272e52e051a9d3946242511b NAME trivia.level0 FILENAME
    trivia_dot_level0 DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION trivia-20200925-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level1
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
