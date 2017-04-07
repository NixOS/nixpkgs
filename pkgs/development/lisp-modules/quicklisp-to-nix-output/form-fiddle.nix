args @ { fetchurl, ... }:
rec {
  baseName = ''form-fiddle'';
  version = ''20160929-git'';

  description = ''A collection of utilities to destructure lambda forms.'';

  deps = [ args."documentation-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/form-fiddle/2016-09-29/form-fiddle-20160929-git.tgz'';
    sha256 = ''1lmdxvwh0d81jlkc9qq2cw0bizjbmk7f5fjcb8ps65andfyj9bd7'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/form-fiddle[.]asd${"$"}' |
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
/* (SYSTEM form-fiddle DESCRIPTION A collection of utilities to destructure lambda forms. SHA256 1lmdxvwh0d81jlkc9qq2cw0bizjbmk7f5fjcb8ps65andfyj9bd7 URL
    http://beta.quicklisp.org/archive/form-fiddle/2016-09-29/form-fiddle-20160929-git.tgz MD5 d7c363b70125a65d909419b78fa7dc24 NAME form-fiddle TESTNAME NIL
    FILENAME form-fiddle DEPS ((NAME documentation-utils)) DEPENDENCIES (documentation-utils) VERSION 20160929-git SIBLINGS NIL) */
