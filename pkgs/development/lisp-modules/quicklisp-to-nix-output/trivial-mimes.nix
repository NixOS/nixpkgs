args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-mimes'';
  version = ''20170630-git'';

  description = ''Tiny library to detect mime types in files.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-mimes/2017-06-30/trivial-mimes-20170630-git.tgz'';
    sha256 = ''0rm667w7nfkcrfjqbb7blbdcrjxbr397a6nqmy35qq82fqjr4rvx'';
  };
    
  packageName = "trivial-mimes";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-mimes[.]asd${"$"}' |
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
/* (SYSTEM trivial-mimes DESCRIPTION Tiny library to detect mime types in files. SHA256 0rm667w7nfkcrfjqbb7blbdcrjxbr397a6nqmy35qq82fqjr4rvx URL
    http://beta.quicklisp.org/archive/trivial-mimes/2017-06-30/trivial-mimes-20170630-git.tgz MD5 5aecea17e102bd2dab7e71fecd1f8e44 NAME trivial-mimes TESTNAME
    NIL FILENAME trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS NIL) */
