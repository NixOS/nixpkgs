args @ { fetchurl, ... }:
rec {
  baseName = ''external-program'';
  version = ''20160825-git'';

  description = '''';

  deps = [ args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/external-program/2016-08-25/external-program-20160825-git.tgz'';
    sha256 = ''0avnnhxxa1wfri9i3m1339nszyp1w2cilycc948nf5awz4mckq13'';
  };
    
  packageName = "external-program";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/external-program[.]asd${"$"}' |
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
/* (SYSTEM external-program DESCRIPTION NIL SHA256 0avnnhxxa1wfri9i3m1339nszyp1w2cilycc948nf5awz4mckq13 URL
    http://beta.quicklisp.org/archive/external-program/2016-08-25/external-program-20160825-git.tgz MD5 6902724c4f762a17645c46b0a1d8efde NAME external-program
    TESTNAME NIL FILENAME external-program DEPS ((NAME trivial-features FILENAME trivial-features)) DEPENDENCIES (trivial-features) VERSION 20160825-git
    SIBLINGS NIL) */
