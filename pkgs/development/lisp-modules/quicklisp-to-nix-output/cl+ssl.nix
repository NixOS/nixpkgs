args @ { fetchurl, ... }:
rec {
  baseName = ''cl+ssl'';
  version = ''cl+ssl-20170403-git'';

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."uiop" args."trivial-gray-streams" args."trivial-garbage" args."flexi-streams" args."cffi" args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2017-04-03/cl+ssl-20170403-git.tgz'';
    sha256 = ''1f1nr1wy6nk0l2n249djcvygl0379ch3x4ndc243jcahcp44x18s'';
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
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256 1f1nr1wy6nk0l2n249djcvygl0379ch3x4ndc243jcahcp44x18s URL
    http://beta.quicklisp.org/archive/cl+ssl/2017-04-03/cl+ssl-20170403-git.tgz MD5 e6d22f98947384d0e0bb2eb18230f72d NAME cl+ssl TESTNAME NIL FILENAME cl+ssl
    DEPS
    ((NAME uiop FILENAME uiop) (NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME flexi-streams FILENAME flexi-streams) (NAME cffi FILENAME cffi) (NAME bordeaux-threads FILENAME bordeaux-threads))
    DEPENDENCIES (uiop trivial-gray-streams trivial-garbage flexi-streams cffi bordeaux-threads) VERSION cl+ssl-20170403-git SIBLINGS (cl+ssl.test)) */
