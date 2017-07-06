args @ { fetchurl, ... }:
rec {
  baseName = ''anaphora'';
  version = ''20170227-git'';

  description = ''The Anaphoric Macro Package from Hell'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/anaphora/2017-02-27/anaphora-20170227-git.tgz'';
    sha256 = ''1inv6bcly6r7yixj1pp0i4h0y7lxyv68mk9wsi5iwi9gx6000yd9'';
  };
    
  packageName = "anaphora";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/anaphora[.]asd${"$"}' |
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
/* (SYSTEM anaphora DESCRIPTION The Anaphoric Macro Package from Hell SHA256 1inv6bcly6r7yixj1pp0i4h0y7lxyv68mk9wsi5iwi9gx6000yd9 URL
    http://beta.quicklisp.org/archive/anaphora/2017-02-27/anaphora-20170227-git.tgz MD5 6121d9bbc92df29d823b60ae0d0c556d NAME anaphora TESTNAME NIL FILENAME
    anaphora DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS NIL) */
