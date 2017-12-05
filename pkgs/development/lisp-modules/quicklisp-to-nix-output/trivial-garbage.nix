args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-garbage'';
  version = ''20150113-git'';

  description = ''Portable finalizers, weak hash-tables and weak pointers.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz'';
    sha256 = ''1yy1jyx7wz5rr7lr0jyyfxgzfddmrxrmkp46a21pcdc4jlss1h08'';
  };
    
  packageName = "trivial-garbage";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-garbage[.]asd${"$"}' |
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
/* (SYSTEM trivial-garbage DESCRIPTION Portable finalizers, weak hash-tables and weak pointers. SHA256 1yy1jyx7wz5rr7lr0jyyfxgzfddmrxrmkp46a21pcdc4jlss1h08 URL
    http://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz MD5 59153568703eed631e53092ab67f935e NAME trivial-garbage
    TESTNAME NIL FILENAME trivial-garbage DEPS NIL DEPENDENCIES NIL VERSION 20150113-git SIBLINGS NIL) */
