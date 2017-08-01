args @ { fetchurl, ... }:
rec {
  baseName = ''hu_dot_dwim_dot_def'';
  version = ''20170630-darcs'';

  description = ''General purpose, homogenous, extensible definer macro.'';

  deps = [ args."metabang-bind" args."iterate" args."anaphora" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.def/2017-06-30/hu.dwim.def-20170630-darcs.tgz'';
    sha256 = ''0flqwj4lxwsl8yknhzzpa1jqr2iza3gnz3vxk645j4z81ynx1cjf'';
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
/* (SYSTEM hu.dwim.def DESCRIPTION General purpose, homogenous, extensible definer macro. SHA256 0flqwj4lxwsl8yknhzzpa1jqr2iza3gnz3vxk645j4z81ynx1cjf URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2017-06-30/hu.dwim.def-20170630-darcs.tgz MD5 def7e4172cbf5ec86a5d51f644d71f81 NAME hu.dwim.def TESTNAME NIL
    FILENAME hu_dot_dwim_dot_def DEPS
    ((NAME metabang-bind FILENAME metabang-bind) (NAME iterate FILENAME iterate) (NAME anaphora FILENAME anaphora) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (metabang-bind iterate anaphora alexandria) VERSION 20170630-darcs SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+contextl hu.dwim.def+hu.dwim.common hu.dwim.def+hu.dwim.delico hu.dwim.def+swank hu.dwim.def.documentation
     hu.dwim.def.namespace hu.dwim.def.test)) */
