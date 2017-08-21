args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20170630-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2017-06-30/documentation-utils-20170630-git.tgz'';
    sha256 = ''0iz3r5llv0rv8l37fdcjrx9zibbaqf9nd6xhy5n2hf024997bbks'';
  };
    
  packageName = "documentation-utils";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/documentation-utils[.]asd${"$"}' |
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
/* (SYSTEM documentation-utils DESCRIPTION A few simple tools to help you with documenting your library. SHA256
    0iz3r5llv0rv8l37fdcjrx9zibbaqf9nd6xhy5n2hf024997bbks URL
    http://beta.quicklisp.org/archive/documentation-utils/2017-06-30/documentation-utils-20170630-git.tgz MD5 7c0541d4207ba221a251c8c3ec7a8cac NAME
    documentation-utils TESTNAME NIL FILENAME documentation-utils DEPS ((NAME trivial-indent FILENAME trivial-indent)) DEPENDENCIES (trivial-indent) VERSION
    20170630-git SIBLINGS NIL) */
