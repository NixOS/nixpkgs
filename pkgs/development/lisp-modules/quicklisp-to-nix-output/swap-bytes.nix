args @ { fetchurl, ... }:
rec {
  baseName = ''swap-bytes'';
  version = ''v1.1'';

  description = ''Optimized byte-swapping primitives.'';

  deps = [ args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/swap-bytes/2016-09-29/swap-bytes-v1.1.tgz'';
    sha256 = ''0snwbfplqhg1y4y4m7lgvksg1hs0sygfikz3rlbkfl4gwg8pq8ky'';
  };
    
  packageName = "swap-bytes";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/swap-bytes[.]asd${"$"}' |
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
/* (SYSTEM swap-bytes DESCRIPTION Optimized byte-swapping primitives. SHA256 0snwbfplqhg1y4y4m7lgvksg1hs0sygfikz3rlbkfl4gwg8pq8ky URL
    http://beta.quicklisp.org/archive/swap-bytes/2016-09-29/swap-bytes-v1.1.tgz MD5 dda8b3b0a4e345879e80a3cc398667bb NAME swap-bytes TESTNAME NIL FILENAME
    swap-bytes DEPS ((NAME trivial-features FILENAME trivial-features)) DEPENDENCIES (trivial-features) VERSION v1.1 SIBLINGS NIL) */
