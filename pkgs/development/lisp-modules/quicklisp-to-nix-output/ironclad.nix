args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''v0.34'';

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2017-05-16/ironclad-v0.34.tgz'';
    sha256 = ''08xlnzs7hzbr0sa4aff4xb0b60dxcpad7fb5xsnjn3qjs7yydxk0'';
  };
    
  packageName = "ironclad";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/ironclad[.]asd${"$"}' |
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
/* (SYSTEM ironclad DESCRIPTION A cryptographic toolkit written in pure Common Lisp SHA256 08xlnzs7hzbr0sa4aff4xb0b60dxcpad7fb5xsnjn3qjs7yydxk0 URL
    http://beta.quicklisp.org/archive/ironclad/2017-05-16/ironclad-v0.34.tgz MD5 82db632975aa83b0dce3412c1aff4a80 NAME ironclad TESTNAME NIL FILENAME ironclad
    DEPS NIL DEPENDENCIES NIL VERSION v0.34 SIBLINGS (ironclad-text)) */
