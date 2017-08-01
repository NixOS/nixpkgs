args @ { fetchurl, ... }:
rec {
  baseName = ''cl+ssl'';
  version = ''cl+ssl-20170725-git'';

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."uiop" args."trivial-gray-streams" args."trivial-garbage" args."trivial-features" args."flexi-streams" args."cffi" args."bordeaux-threads" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2017-07-25/cl+ssl-20170725-git.tgz'';
    sha256 = ''1p5886l5bwz4bj2xy8mpsjswg103b8saqdnw050a4wk9shpj1j69'';
  };
    
  packageName = "cl+ssl";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl+ssl[.]asd${"$"}' |
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
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256 1p5886l5bwz4bj2xy8mpsjswg103b8saqdnw050a4wk9shpj1j69 URL
    http://beta.quicklisp.org/archive/cl+ssl/2017-07-25/cl+ssl-20170725-git.tgz MD5 3458c83f442395e0492c7e9b9720a1f2 NAME cl+ssl TESTNAME NIL FILENAME cl+ssl
    DEPS
    ((NAME uiop FILENAME uiop) (NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-features FILENAME trivial-features) (NAME flexi-streams FILENAME flexi-streams) (NAME cffi FILENAME cffi)
     (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (uiop trivial-gray-streams trivial-garbage trivial-features flexi-streams cffi bordeaux-threads alexandria) VERSION cl+ssl-20170725-git
    SIBLINGS (cl+ssl.test)) */
