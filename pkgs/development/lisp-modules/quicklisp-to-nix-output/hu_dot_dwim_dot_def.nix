args @ { fetchurl, ... }:
rec {
  baseName = ''hu_dot_dwim_dot_def'';
  version = ''20170516-darcs'';

  description = ''General purpose, homogenous, extensible definer macro.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.def/2017-05-16/hu.dwim.def-20170516-darcs.tgz'';
    sha256 = ''1x333jiihgqydv234q8wjsy5n8nfr6n4mpwq08f1b497if4fc7by'';
  };
    
  packageName = "hu.dwim.def";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/hu.dwim.def[.]asd${"$"}' |
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
/* (SYSTEM hu.dwim.def DESCRIPTION General purpose, homogenous, extensible definer macro. SHA256 1x333jiihgqydv234q8wjsy5n8nfr6n4mpwq08f1b497if4fc7by URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2017-05-16/hu.dwim.def-20170516-darcs.tgz MD5 bd13311ab8da2a67f9247e825369b294 NAME hu.dwim.def TESTNAME NIL
    FILENAME hu_dot_dwim_dot_def DEPS NIL DEPENDENCIES NIL VERSION 20170516-darcs SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+contextl hu.dwim.def+hu.dwim.common hu.dwim.def+hu.dwim.delico hu.dwim.def+swank hu.dwim.def.documentation
     hu.dwim.def.namespace hu.dwim.def.test)) */
