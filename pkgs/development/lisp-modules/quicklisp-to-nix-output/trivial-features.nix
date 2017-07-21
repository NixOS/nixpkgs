args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-features'';
  version = ''20161204-git'';

  description = ''Ensures consistent *FEATURES* across multiple CLs.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-features/2016-12-04/trivial-features-20161204-git.tgz'';
    sha256 = ''0i2zyc9c7jigljxll29sh9gv1fawdsf0kq7s86pwba5zi99q2ij2'';
  };
    
  packageName = "trivial-features";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-features[.]asd${"$"}' |
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
/* (SYSTEM trivial-features DESCRIPTION Ensures consistent *FEATURES* across multiple CLs. SHA256 0i2zyc9c7jigljxll29sh9gv1fawdsf0kq7s86pwba5zi99q2ij2 URL
    http://beta.quicklisp.org/archive/trivial-features/2016-12-04/trivial-features-20161204-git.tgz MD5 07497e3fd92e68027a96f877cfe62bd4 NAME trivial-features
    TESTNAME NIL FILENAME trivial-features DEPS NIL DEPENDENCIES NIL VERSION 20161204-git SIBLINGS (trivial-features-tests)) */
