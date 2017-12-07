args @ { fetchurl, ... }:
rec {
  baseName = ''proc-parse'';
  version = ''20160318-git'';

  description = ''Procedural vector parser'';

  deps = [ args."babel" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/proc-parse/2016-03-18/proc-parse-20160318-git.tgz'';
    sha256 = ''00261w269w9chg6r3sh8hg8994njbsai1g3zni0whm2dzxxq6rnl'';
  };
    
  packageName = "proc-parse";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/proc-parse[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM proc-parse DESCRIPTION Procedural vector parser SHA256 00261w269w9chg6r3sh8hg8994njbsai1g3zni0whm2dzxxq6rnl URL
    http://beta.quicklisp.org/archive/proc-parse/2016-03-18/proc-parse-20160318-git.tgz MD5 5e43f50284fa70c448a3df12d1eea2ea NAME proc-parse TESTNAME NIL
    FILENAME proc-parse DEPS ((NAME babel FILENAME babel) (NAME alexandria FILENAME alexandria)) DEPENDENCIES (babel alexandria) VERSION 20160318-git SIBLINGS
    (proc-parse-test)) */
