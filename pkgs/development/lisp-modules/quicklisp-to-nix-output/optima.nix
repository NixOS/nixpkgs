args @ { fetchurl, ... }:
rec {
  baseName = ''optima'';
  version = ''20150709-git'';

  description = ''Optimized Pattern Matching Library'';

  deps = [ args."closer-mop" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/optima/2015-07-09/optima-20150709-git.tgz'';
    sha256 = ''0vqyqrnx2d8qwa2jlg9l2wn6vrykraj8a1ysz0gxxxnwpqc29hdc'';
  };
    
  packageName = "optima";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/optima[.]asd${"$"}' |
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
/* (SYSTEM optima DESCRIPTION Optimized Pattern Matching Library SHA256 0vqyqrnx2d8qwa2jlg9l2wn6vrykraj8a1ysz0gxxxnwpqc29hdc URL
    http://beta.quicklisp.org/archive/optima/2015-07-09/optima-20150709-git.tgz MD5 20523dc3dfc04bb2526008dff0842caa NAME optima TESTNAME NIL FILENAME optima
    DEPS ((NAME closer-mop FILENAME closer-mop) (NAME alexandria FILENAME alexandria)) DEPENDENCIES (closer-mop alexandria) VERSION 20150709-git SIBLINGS
    (optima.ppcre optima.test)) */
