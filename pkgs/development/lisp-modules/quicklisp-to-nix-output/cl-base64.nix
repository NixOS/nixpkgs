args @ { fetchurl, ... }:
rec {
  baseName = ''cl-base64'';
  version = ''20150923-git'';

  description = ''Base64 encoding and decoding with URI support.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz'';
    sha256 = ''0haip5x0091r9xa8gdzr21s0rk432998nbxxfys35lhnyc1vgyhp'';
  };
    
  packageName = "cl-base64";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-base64[.]asd${"$"}' |
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
/* (SYSTEM cl-base64 DESCRIPTION Base64 encoding and decoding with URI support. SHA256 0haip5x0091r9xa8gdzr21s0rk432998nbxxfys35lhnyc1vgyhp URL
    http://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz MD5 560d0601eaa86901611f1484257b9a57 NAME cl-base64 TESTNAME NIL FILENAME
    cl-base64 DEPS NIL DEPENDENCIES NIL VERSION 20150923-git SIBLINGS NIL) */
