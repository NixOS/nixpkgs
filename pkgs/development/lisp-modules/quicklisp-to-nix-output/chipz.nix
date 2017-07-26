args @ { fetchurl, ... }:
rec {
  baseName = ''chipz'';
  version = ''20160318-git'';

  description = ''A library for decompressing deflate, zlib, and gzip data'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chipz/2016-03-18/chipz-20160318-git.tgz'';
    sha256 = ''1dpsg8kd43k075xihb0szcq1f7iq8ryg5r77x5wi6hy9jhpq8826'';
  };
    
  packageName = "chipz";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/chipz[.]asd${"$"}' |
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
/* (SYSTEM chipz DESCRIPTION A library for decompressing deflate, zlib, and gzip data SHA256 1dpsg8kd43k075xihb0szcq1f7iq8ryg5r77x5wi6hy9jhpq8826 URL
    http://beta.quicklisp.org/archive/chipz/2016-03-18/chipz-20160318-git.tgz MD5 625cb9c551f3692799e2029d4a0dd7e9 NAME chipz TESTNAME NIL FILENAME chipz DEPS
    NIL DEPENDENCIES NIL VERSION 20160318-git SIBLINGS NIL) */
