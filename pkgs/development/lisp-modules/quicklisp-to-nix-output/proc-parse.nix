args @ { fetchurl, ... }:
rec {
  baseName = ''proc-parse'';
  version = ''20190813-git'';

  description = ''Procedural vector parser'';

  deps = [ args."alexandria" args."babel" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/proc-parse/2019-08-13/proc-parse-20190813-git.tgz'';
    sha256 = ''126l7mqxjcgw2limddgrdq63cdhwkhaxabxl9l0bjadf92nczg0j'';
  };

  packageName = "proc-parse";

  asdFilesToKeep = ["proc-parse.asd"];
  overrides = x: x;
}
/* (SYSTEM proc-parse DESCRIPTION Procedural vector parser SHA256
    126l7mqxjcgw2limddgrdq63cdhwkhaxabxl9l0bjadf92nczg0j URL
    http://beta.quicklisp.org/archive/proc-parse/2019-08-13/proc-parse-20190813-git.tgz
    MD5 99bdce79943071267c6a877d8de246c5 NAME proc-parse FILENAME proc-parse
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel trivial-features) VERSION 20190813-git
    SIBLINGS (proc-parse-test) PARASITES NIL) */
