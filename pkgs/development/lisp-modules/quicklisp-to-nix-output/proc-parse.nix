args @ { fetchurl, ... }:
rec {
  baseName = ''proc-parse'';
  version = ''20160318-git'';

  description = ''Procedural vector parser'';

  deps = [ args."alexandria" args."babel" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/proc-parse/2016-03-18/proc-parse-20160318-git.tgz'';
    sha256 = ''00261w269w9chg6r3sh8hg8994njbsai1g3zni0whm2dzxxq6rnl'';
  };

  packageName = "proc-parse";

  asdFilesToKeep = ["proc-parse.asd"];
  overrides = x: x;
}
/* (SYSTEM proc-parse DESCRIPTION Procedural vector parser SHA256
    00261w269w9chg6r3sh8hg8994njbsai1g3zni0whm2dzxxq6rnl URL
    http://beta.quicklisp.org/archive/proc-parse/2016-03-18/proc-parse-20160318-git.tgz
    MD5 5e43f50284fa70c448a3df12d1eea2ea NAME proc-parse FILENAME proc-parse
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel trivial-features) VERSION 20160318-git
    SIBLINGS (proc-parse-test) PARASITES NIL) */
