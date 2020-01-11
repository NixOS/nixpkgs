args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_level1'';
  version = ''trivia-20190710-git'';

  description = ''Core patterns of Trivia'';

  deps = [ args."alexandria" args."trivia_dot_level0" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2019-07-10/trivia-20190710-git.tgz'';
    sha256 = ''0601gms5n60c6cgkh78a50a3m1n3mb1a39p5k4hb69yx1vnmz6ic'';
  };

  packageName = "trivia.level1";

  asdFilesToKeep = ["trivia.level1.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level1 DESCRIPTION Core patterns of Trivia SHA256
    0601gms5n60c6cgkh78a50a3m1n3mb1a39p5k4hb69yx1vnmz6ic URL
    http://beta.quicklisp.org/archive/trivia/2019-07-10/trivia-20190710-git.tgz
    MD5 f17ca476901eaff8d3e5d32de23b7447 NAME trivia.level1 FILENAME
    trivia_dot_level1 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivia.level0 FILENAME trivia_dot_level0))
    DEPENDENCIES (alexandria trivia.level0) VERSION trivia-20190710-git
    SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
