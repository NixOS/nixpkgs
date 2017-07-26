args @ { fetchurl, ... }:
rec {
  baseName = ''iolib'';
  version = ''v0.8.2'';

  description = ''I/O library.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2017-05-16/iolib-v0.8.2.tgz'';
    sha256 = ''1k0wkkgzy6fmq28dw6xbx86l1j9x3nrmrzpv6jcmcdb078h820pr'';
  };
    
  packageName = "iolib";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/iolib[.]asd${"$"}' |
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
/* (SYSTEM iolib DESCRIPTION I/O library. SHA256 1k0wkkgzy6fmq28dw6xbx86l1j9x3nrmrzpv6jcmcdb078h820pr URL
    http://beta.quicklisp.org/archive/iolib/2017-05-16/iolib-v0.8.2.tgz MD5 cd2d4d2893b7e6d0502d9a16e717a2e9 NAME iolib TESTNAME NIL FILENAME iolib DEPS NIL
    DEPENDENCIES NIL VERSION v0.8.2 SIBLINGS (iolib.asdf iolib.base iolib.common-lisp iolib.conf iolib.examples iolib.grovel iolib.tests)) */
