args @ { fetchurl, ... }:
rec {
  baseName = ''parse-number'';
  version = ''1.4'';

  description = ''Number parsing library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz'';
    sha256 = ''0y8jh7ss47z3asdxknad2g8h12nclvx0by750xniizj33b6h9blh'';
  };
    
  packageName = "parse-number";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/parse-number[.]asd${"$"}' |
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
/* (SYSTEM parse-number DESCRIPTION Number parsing library SHA256 0y8jh7ss47z3asdxknad2g8h12nclvx0by750xniizj33b6h9blh URL
    http://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz MD5 f189d474a2cd063f9743b452241e59a9 NAME parse-number TESTNAME NIL FILENAME
    parse-number DEPS NIL DEPENDENCIES NIL VERSION 1.4 SIBLINGS NIL) */
