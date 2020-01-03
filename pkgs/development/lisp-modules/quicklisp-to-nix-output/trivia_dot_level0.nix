args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_level0'';
  version = ''trivia-20190710-git'';

  description = ''Bootstrapping Pattern Matching Library for implementing Trivia'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2019-07-10/trivia-20190710-git.tgz'';
    sha256 = ''0601gms5n60c6cgkh78a50a3m1n3mb1a39p5k4hb69yx1vnmz6ic'';
  };

  packageName = "trivia.level0";

  asdFilesToKeep = ["trivia.level0.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level0 DESCRIPTION
    Bootstrapping Pattern Matching Library for implementing Trivia SHA256
    0601gms5n60c6cgkh78a50a3m1n3mb1a39p5k4hb69yx1vnmz6ic URL
    http://beta.quicklisp.org/archive/trivia/2019-07-10/trivia-20190710-git.tgz
    MD5 f17ca476901eaff8d3e5d32de23b7447 NAME trivia.level0 FILENAME
    trivia_dot_level0 DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION trivia-20190710-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level1
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
