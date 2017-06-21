args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-mimes'';
  version = ''20170516-git'';

  description = ''Tiny library to detect mime types in files.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-mimes/2017-05-16/trivial-mimes-20170516-git.tgz'';
    sha256 = ''1prv15krlcwwb9jwqvskm588y2yh7r2n6c4c80fh0f2r73ysfnj2'';
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
/* (SYSTEM trivial-mimes DESCRIPTION Tiny library to detect mime types in files. SHA256 1prv15krlcwwb9jwqvskm588y2yh7r2n6c4c80fh0f2r73ysfnj2 URL
    http://beta.quicklisp.org/archive/trivial-mimes/2017-05-16/trivial-mimes-20170516-git.tgz MD5 b9cbba4147647ded4042949db3c00f1e NAME trivial-mimes TESTNAME
    NIL FILENAME trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
