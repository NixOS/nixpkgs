args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fad'';
  version = ''0.7.4'';

  description = ''Portable pathname library'';

  deps = [ args."alexandria" args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fad/2016-08-25/cl-fad-0.7.4.tgz'';
    sha256 = ''1avp5j66vrpv5symgw4n4szlc2cyqz4haa0cxzy1pl8p0a8k0v9x'';
  };
    
  packageName = "cl-fad";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-fad[.]asd${"$"}' |
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
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256 1avp5j66vrpv5symgw4n4szlc2cyqz4haa0cxzy1pl8p0a8k0v9x URL
    http://beta.quicklisp.org/archive/cl-fad/2016-08-25/cl-fad-0.7.4.tgz MD5 8ee53f2249eca9d7d54e268662b41845 NAME cl-fad TESTNAME NIL FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria) (NAME bordeaux-threads FILENAME bordeaux-threads)) DEPENDENCIES (alexandria bordeaux-threads) VERSION 0.7.4 SIBLINGS
    NIL) */
