args @ { fetchurl, ... }:
rec {
  baseName = ''puri'';
  version = ''20150923-git'';

  description = ''Portable Universal Resource Indentifier Library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz'';
    sha256 = ''099ay2zji5ablj2jj56sb49hk2l9x5s11vpx6893qwwjsp2881qa'';
  };
    
  packageName = "puri";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/puri[.]asd${"$"}' |
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
/* (SYSTEM puri DESCRIPTION Portable Universal Resource Indentifier Library SHA256 099ay2zji5ablj2jj56sb49hk2l9x5s11vpx6893qwwjsp2881qa URL
    http://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz MD5 3bd4e30aa6b6baf6f26753b5fc357e0f NAME puri TESTNAME NIL FILENAME puri DEPS NIL
    DEPENDENCIES NIL VERSION 20150923-git SIBLINGS NIL) */
