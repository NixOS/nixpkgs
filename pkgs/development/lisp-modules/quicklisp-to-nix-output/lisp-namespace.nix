args @ { fetchurl, ... }:
rec {
  baseName = ''lisp-namespace'';
  version = ''20170630-git'';

  description = ''Provides LISP-N --- extensible namespaces in Common Lisp.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lisp-namespace/2017-06-30/lisp-namespace-20170630-git.tgz'';
    sha256 = ''06mdrzjwmfynzljcs8ym8dscjlxpbbkmjfg912v68v7p2xzq6d0n'';
  };
    
  packageName = "lisp-namespace";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/lisp-namespace[.]asd${"$"}' |
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
/* (SYSTEM lisp-namespace DESCRIPTION Provides LISP-N --- extensible namespaces in Common Lisp. SHA256 06mdrzjwmfynzljcs8ym8dscjlxpbbkmjfg912v68v7p2xzq6d0n URL
    http://beta.quicklisp.org/archive/lisp-namespace/2017-06-30/lisp-namespace-20170630-git.tgz MD5 f3379a60f7cc896a7cff384ff25a1de5 NAME lisp-namespace
    TESTNAME NIL FILENAME lisp-namespace DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION 20170630-git SIBLINGS
    (lisp-namespace.test)) */
