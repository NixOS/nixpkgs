args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20170516-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2017-05-16/clss-20170516-git.tgz'';
    sha256 = ''1c3fizlf4509hj4l6m9gjc64ijvlwnavwvvw3198cvvn6lp49r5f'';
  };
    
  packageName = "clss";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clss[.]asd${"$"}' |
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
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors. SHA256 1c3fizlf4509hj4l6m9gjc64ijvlwnavwvvw3198cvvn6lp49r5f URL
    http://beta.quicklisp.org/archive/clss/2017-05-16/clss-20170516-git.tgz MD5 2e69a5197694a9654c0e9c5fced4152f NAME clss TESTNAME NIL FILENAME clss DEPS NIL
    DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
