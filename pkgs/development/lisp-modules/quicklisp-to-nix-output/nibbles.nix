args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20170403-git'';

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2017-04-03/nibbles-20170403-git.tgz'';
    sha256 = ''0bg7jwhqhm3qmpzk21gjv50sl0grdn68d770cqfs7in62ny35lk4'';
  };
    
  packageName = "nibbles";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/nibbles[.]asd${"$"}' |
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
/* (SYSTEM nibbles DESCRIPTION A library for accessing octet-addressed blocks of data in big- and little-endian orders SHA256
    0bg7jwhqhm3qmpzk21gjv50sl0grdn68d770cqfs7in62ny35lk4 URL http://beta.quicklisp.org/archive/nibbles/2017-04-03/nibbles-20170403-git.tgz MD5
    5683a0a5510860a036b2a272036cda87 NAME nibbles TESTNAME NIL FILENAME nibbles DEPS NIL DEPENDENCIES NIL VERSION 20170403-git SIBLINGS NIL) */
