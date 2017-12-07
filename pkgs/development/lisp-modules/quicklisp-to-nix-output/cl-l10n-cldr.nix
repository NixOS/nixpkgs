args @ { fetchurl, ... }:
rec {
  baseName = ''cl-l10n-cldr'';
  version = ''20120909-darcs'';

  description = ''The necessary CLDR files for cl-l10n packaged in a QuickLisp friendly way.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-l10n-cldr/2012-09-09/cl-l10n-cldr-20120909-darcs.tgz'';
    sha256 = ''03l81bx8izvzwzw0qah34l4k47l4gmhr917phhhl81qp55x7zbiv'';
  };
    
  packageName = "cl-l10n-cldr";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-l10n-cldr[.]asd${"$"}' |
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
/* (SYSTEM cl-l10n-cldr DESCRIPTION The necessary CLDR files for cl-l10n packaged in a QuickLisp friendly way. SHA256
    03l81bx8izvzwzw0qah34l4k47l4gmhr917phhhl81qp55x7zbiv URL http://beta.quicklisp.org/archive/cl-l10n-cldr/2012-09-09/cl-l10n-cldr-20120909-darcs.tgz MD5
    466e776f2f6b931d9863e1fc4d0b514e NAME cl-l10n-cldr TESTNAME NIL FILENAME cl-l10n-cldr DEPS NIL DEPENDENCIES NIL VERSION 20120909-darcs SIBLINGS NIL) */
