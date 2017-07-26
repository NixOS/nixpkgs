args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.2.1'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2017-05-16/uiop-3.2.1.tgz'';
    sha256 = ''1zl661dkbg5clyl5fjj9466krk59xfdmmfzci5mj7n137m0zmf5v'';
  };
    
  packageName = "uiop";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/uiop[.]asd${"$"}' |
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
/* (SYSTEM uiop DESCRIPTION NIL SHA256 1zl661dkbg5clyl5fjj9466krk59xfdmmfzci5mj7n137m0zmf5v URL
    http://beta.quicklisp.org/archive/uiop/2017-05-16/uiop-3.2.1.tgz MD5 3e9ef02ecf9005240b66552d85719700 NAME uiop TESTNAME NIL FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.2.1 SIBLINGS (asdf-driver)) */
