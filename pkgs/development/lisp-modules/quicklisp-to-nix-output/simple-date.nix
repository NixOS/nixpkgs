args @ { fetchurl, ... }:
rec {
  baseName = ''simple-date'';
  version = ''postmodern-20170403-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz'';
    sha256 = ''1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p'';
  };
    
  packageName = "simple-date";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/simple-date[.]asd${"$"}' |
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
/* (SYSTEM simple-date DESCRIPTION NIL SHA256 1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p URL
    http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz MD5 7a4145a0a5ff5bcb7a4bf29b5c2915d2 NAME simple-date TESTNAME NIL
    FILENAME simple-date DEPS NIL DEPENDENCIES NIL VERSION postmodern-20170403-git SIBLINGS (cl-postgres postmodern s-sql)) */
