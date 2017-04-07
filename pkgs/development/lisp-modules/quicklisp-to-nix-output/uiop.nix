args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.2.0'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2017-01-24/uiop-3.2.0.tgz'';
    sha256 = ''1rrn1mdcb4dmb517vrp3nzwpp1w8hfvpzarj36c7kkpjq23czdig'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/uiop[.]asd${"$"}' |
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
/* (SYSTEM uiop DESCRIPTION NIL SHA256 1rrn1mdcb4dmb517vrp3nzwpp1w8hfvpzarj36c7kkpjq23czdig URL
    http://beta.quicklisp.org/archive/uiop/2017-01-24/uiop-3.2.0.tgz MD5 3c304efce790959b14a241db2e669fce NAME uiop TESTNAME NIL FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.2.0 SIBLINGS (asdf-driver)) */
