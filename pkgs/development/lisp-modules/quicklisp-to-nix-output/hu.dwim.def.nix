args @ { fetchurl, ... }:
rec {
  baseName = ''hu.dwim.def'';
  version = ''20161204-darcs'';

  description = ''General purpose, homogenous, extensible definer macro.'';

  deps = [ args."metabang-bind" args."iterate" args."hu.dwim.asdf" args."anaphora" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.def/2016-12-04/hu.dwim.def-20161204-darcs.tgz'';
    sha256 = ''0znvcm4zi8rivyk0s840v8jaa52hzdiql88pk8hnaj8abxkvl3lj'';
  };

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
/* (SYSTEM hu.dwim.def DESCRIPTION General purpose, homogenous, extensible definer macro. SHA256 0znvcm4zi8rivyk0s840v8jaa52hzdiql88pk8hnaj8abxkvl3lj URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2016-12-04/hu.dwim.def-20161204-darcs.tgz MD5 c4a85c220873a9edd1c2c49a6498baca NAME hu.dwim.def TESTNAME NIL
    FILENAME hu.dwim.def DEPS ((NAME metabang-bind) (NAME iterate) (NAME hu.dwim.asdf) (NAME anaphora) (NAME alexandria)) DEPENDENCIES
    (metabang-bind iterate hu.dwim.asdf anaphora alexandria) VERSION 20161204-darcs SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+contextl hu.dwim.def+hu.dwim.common hu.dwim.def+hu.dwim.delico hu.dwim.def+swank hu.dwim.def.documentation
     hu.dwim.def.namespace hu.dwim.def.test)) */
