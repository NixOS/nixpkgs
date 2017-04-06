args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20161204-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2016-12-04/documentation-utils-20161204-git.tgz'';
    sha256 = ''0vyj5nvy697w2fvp2rb42jxgqah85ivz1hg84amqfi4bvik2npvq'';
  };

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
    0vyj5nvy697w2fvp2rb42jxgqah85ivz1hg84amqfi4bvik2npvq URL
    http://beta.quicklisp.org/archive/documentation-utils/2016-12-04/documentation-utils-20161204-git.tgz MD5 36a233bf438bfc067b074b6a05865c33 NAME
    documentation-utils TESTNAME NIL FILENAME documentation-utils DEPS ((NAME trivial-indent)) DEPENDENCIES (trivial-indent) VERSION 20161204-git SIBLINGS NIL) */
