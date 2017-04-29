args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20170403-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2017-04-03/stumpwm-20170403-git.tgz'';
    sha256 = ''1aca1nvdzp957mvwxz6x0plkg915l24mjf89h8rgkgclkn6xk4rf'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/stumpwm[.]asd${"$"}' |
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
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256 1aca1nvdzp957mvwxz6x0plkg915l24mjf89h8rgkgclkn6xk4rf URL
    http://beta.quicklisp.org/archive/stumpwm/2017-04-03/stumpwm-20170403-git.tgz MD5 1081021518c5b6c36d39f12c47305ea1 NAME stumpwm TESTNAME NIL FILENAME
    stumpwm DEPS ((NAME alexandria) (NAME cl-ppcre) (NAME clx)) DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20170403-git SIBLINGS NIL) */
