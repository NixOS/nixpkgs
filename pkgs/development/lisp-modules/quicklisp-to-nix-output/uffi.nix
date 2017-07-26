args @ { fetchurl, ... }:
rec {
  baseName = ''uffi'';
  version = ''20150923-git'';

  description = ''Universal Foreign Function Library for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uffi/2015-09-23/uffi-20150923-git.tgz'';
    sha256 = ''1b3mb1ac5hqpn941pmgwkiy241rnin308haxbs2f4rwp2la7wzyy'';
  };
    
  packageName = "uffi";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/uffi[.]asd${"$"}' |
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
/* (SYSTEM uffi DESCRIPTION Universal Foreign Function Library for Common Lisp SHA256 1b3mb1ac5hqpn941pmgwkiy241rnin308haxbs2f4rwp2la7wzyy URL
    http://beta.quicklisp.org/archive/uffi/2015-09-23/uffi-20150923-git.tgz MD5 84babed7d1633cf01610e81f027024da NAME uffi TESTNAME NIL FILENAME uffi DEPS NIL
    DEPENDENCIES NIL VERSION 20150923-git SIBLINGS (uffi-tests)) */
