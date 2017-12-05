args @ { fetchurl, ... }:
rec {
  baseName = ''fset'';
  version = ''20150113-git'';

  description = ''A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html
'';

  deps = [ args."misc-extensions" args."mt19937" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fset/2015-01-13/fset-20150113-git.tgz'';
    sha256 = ''1k9c48jahw8i4zhx6dc96n0jzxjy2ascr2wng9hmm8vjhhqs5sl0'';
  };
    
  packageName = "fset";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/fset[.]asd${"$"}' |
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
/* (SYSTEM fset DESCRIPTION A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html

    SHA256 1k9c48jahw8i4zhx6dc96n0jzxjy2ascr2wng9hmm8vjhhqs5sl0 URL http://beta.quicklisp.org/archive/fset/2015-01-13/fset-20150113-git.tgz MD5
    89f958cc900e712aed0750b336efbe15 NAME fset TESTNAME NIL FILENAME fset DEPS
    ((NAME misc-extensions FILENAME misc-extensions) (NAME mt19937 FILENAME mt19937)) DEPENDENCIES (misc-extensions mt19937) VERSION 20150113-git SIBLINGS NIL) */
