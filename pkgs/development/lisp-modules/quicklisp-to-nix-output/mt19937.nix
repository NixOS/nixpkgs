args @ { fetchurl, ... }:
rec {
  baseName = ''mt19937'';
  version = ''1.1.1'';

  description = ''Portable MT19937 Mersenne Twister random number generator'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/mt19937/2011-02-19/mt19937-1.1.1.tgz'';
    sha256 = ''1iw636b0iw5ygkv02y8i41lh7xj0acglv0hg5agryn0zzi2nf1xv'';
  };
    
  packageName = "mt19937";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/mt19937[.]asd${"$"}' |
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
/* (SYSTEM mt19937 DESCRIPTION Portable MT19937 Mersenne Twister random number generator SHA256 1iw636b0iw5ygkv02y8i41lh7xj0acglv0hg5agryn0zzi2nf1xv URL
    http://beta.quicklisp.org/archive/mt19937/2011-02-19/mt19937-1.1.1.tgz MD5 54c63977b6d77abd66ebe0227b77c143 NAME mt19937 TESTNAME NIL FILENAME mt19937 DEPS
    NIL DEPENDENCIES NIL VERSION 1.1.1 SIBLINGS NIL) */
