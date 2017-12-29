args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-types'';
  version = ''20120407-git'';

  description = ''Trivial type definitions'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-types/2012-04-07/trivial-types-20120407-git.tgz'';
    sha256 = ''0y3lfbbvi2qp2cwswzmk1awzqrsrrcfkcm1qn744bgm1fiqhxbxx'';
  };
    
  packageName = "trivial-types";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-types[.]asd${"$"}' |
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
/* (SYSTEM trivial-types DESCRIPTION Trivial type definitions SHA256 0y3lfbbvi2qp2cwswzmk1awzqrsrrcfkcm1qn744bgm1fiqhxbxx URL
    http://beta.quicklisp.org/archive/trivial-types/2012-04-07/trivial-types-20120407-git.tgz MD5 b14dbe0564dcea33d8f4e852a612d7db NAME trivial-types TESTNAME
    NIL FILENAME trivial-types DEPS NIL DEPENDENCIES NIL VERSION 20120407-git SIBLINGS NIL) */
