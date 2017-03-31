args @ { fetchurl, ... }:
rec {
  baseName = ''proc-parse'';
  version = ''20160318-git'';

  description = ''Procedural vector parser'';

  deps = [ args."alexandria" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/proc-parse/2016-03-18/proc-parse-20160318-git.tgz'';
    sha256 = ''00261w269w9chg6r3sh8hg8994njbsai1g3zni0whm2dzxxq6rnl'';
  };

  overrides = x: {
  };
}
