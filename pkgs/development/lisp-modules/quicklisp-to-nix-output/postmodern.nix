args @ { fetchurl, ... }:
rec {
  baseName = ''postmodern'';
  version = ''20170403-git'';

  description = ''PostgreSQL programming API'';

  deps = [ args."closer-mop" args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz'';
    sha256 = ''1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p'';
  };
    
  packageName = "postmodern";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/postmodern[.]asd${"$"}' |
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
/* (SYSTEM postmodern DESCRIPTION PostgreSQL programming API SHA256 1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p URL
    http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz MD5 7a4145a0a5ff5bcb7a4bf29b5c2915d2 NAME postmodern TESTNAME NIL
    FILENAME postmodern DEPS ((NAME closer-mop FILENAME closer-mop) (NAME bordeaux-threads FILENAME bordeaux-threads)) DEPENDENCIES
    (closer-mop bordeaux-threads) VERSION 20170403-git SIBLINGS (cl-postgres s-sql simple-date)) */
