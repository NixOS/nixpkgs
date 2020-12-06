args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_level1'';
  version = ''trivia-20200925-git'';

  description = ''Core patterns of Trivia'';

  deps = [ args."alexandria" args."trivia_dot_level0" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz'';
    sha256 = ''192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z'';
  };

  packageName = "trivia.level1";

  asdFilesToKeep = ["trivia.level1.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level1 DESCRIPTION Core patterns of Trivia SHA256
    192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z URL
    http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz
    MD5 c6546ecf272e52e051a9d3946242511b NAME trivia.level1 FILENAME
    trivia_dot_level1 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivia.level0 FILENAME trivia_dot_level0))
    DEPENDENCIES (alexandria trivia.level0) VERSION trivia-20200925-git
    SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
