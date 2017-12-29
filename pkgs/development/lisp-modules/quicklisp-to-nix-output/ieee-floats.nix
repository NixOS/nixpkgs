args @ { fetchurl, ... }:
rec {
  baseName = ''ieee-floats'';
  version = ''20160318-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ieee-floats/2016-03-18/ieee-floats-20160318-git.tgz'';
    sha256 = ''0vw4q6q5yygfxfwx5bki4kl9lqszmhnplcl55qh8raxmb03alyx4'';
  };
    
  packageName = "ieee-floats";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/ieee-floats[.]asd${"$"}' |
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
/* (SYSTEM ieee-floats DESCRIPTION NIL SHA256 0vw4q6q5yygfxfwx5bki4kl9lqszmhnplcl55qh8raxmb03alyx4 URL
    http://beta.quicklisp.org/archive/ieee-floats/2016-03-18/ieee-floats-20160318-git.tgz MD5 84d679a4dffddc3b0cff944adde623c5 NAME ieee-floats TESTNAME NIL
    FILENAME ieee-floats DEPS NIL DEPENDENCIES NIL VERSION 20160318-git SIBLINGS NIL) */
