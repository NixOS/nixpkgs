args @ { fetchurl, ... }:
rec {
  baseName = ''cl-test-more'';
  version = ''prove-20170403-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz'';
    sha256 = ''091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl'';
  };
    
  packageName = "cl-test-more";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-test-more[.]asd${"$"}' |
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
/* (SYSTEM cl-test-more DESCRIPTION NIL SHA256 091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl URL
    http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz MD5 063b615692c8711d2392204ecf1b37b7 NAME cl-test-more TESTNAME NIL FILENAME
    cl-test-more DEPS NIL DEPENDENCIES NIL VERSION prove-20170403-git SIBLINGS (prove-asdf prove-test prove)) */
