args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_level1'';
  version = ''trivia-20191227-git'';

  description = ''Core patterns of Trivia'';

  deps = [ args."alexandria" args."trivia_dot_level0" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2019-12-27/trivia-20191227-git.tgz'';
    sha256 = ''1hn6klc2jlh2qhlc4zr9fi02kqlyfyh5bkcgirql1m06g4j8qi4q'';
  };

  packageName = "trivia.level1";

  asdFilesToKeep = ["trivia.level1.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level1 DESCRIPTION Core patterns of Trivia SHA256
    1hn6klc2jlh2qhlc4zr9fi02kqlyfyh5bkcgirql1m06g4j8qi4q URL
    http://beta.quicklisp.org/archive/trivia/2019-12-27/trivia-20191227-git.tgz
    MD5 645f0e0fcf57ab37ebd4f0a1b7b05854 NAME trivia.level1 FILENAME
    trivia_dot_level1 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivia.level0 FILENAME trivia_dot_level0))
    DEPENDENCIES (alexandria trivia.level0) VERSION trivia-20191227-git
    SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
