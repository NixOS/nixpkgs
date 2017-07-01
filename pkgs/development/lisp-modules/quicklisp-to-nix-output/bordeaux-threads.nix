args @ { fetchurl, ... }:
rec {
  baseName = ''bordeaux-threads'';
  version = ''v0.8.5'';

  description = ''Bordeaux Threads makes writing portable multi-threaded apps simple.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/bordeaux-threads/2016-03-18/bordeaux-threads-v0.8.5.tgz'';
    sha256 = ''09q1xd3fca6ln6mh45cx24xzkrcnvhgl5nn9g2jv0rwj1m2xvbpd'';
  };
    
  packageName = "bordeaux-threads";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/bordeaux-threads[.]asd${"$"}' |
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
/* (SYSTEM bordeaux-threads DESCRIPTION Bordeaux Threads makes writing portable multi-threaded apps simple. SHA256
    09q1xd3fca6ln6mh45cx24xzkrcnvhgl5nn9g2jv0rwj1m2xvbpd URL http://beta.quicklisp.org/archive/bordeaux-threads/2016-03-18/bordeaux-threads-v0.8.5.tgz MD5
    67e363a363e164b6f61a047957b8554e NAME bordeaux-threads TESTNAME NIL FILENAME bordeaux-threads DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION v0.8.5 SIBLINGS NIL) */
