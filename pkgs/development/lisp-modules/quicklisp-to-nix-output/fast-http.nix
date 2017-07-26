args @ { fetchurl, ... }:
rec {
  baseName = ''fast-http'';
  version = ''20170227-git'';

  description = ''A fast HTTP protocol parser in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-http/2017-02-27/fast-http-20170227-git.tgz'';
    sha256 = ''0kpfn4i5r12hfnb3j00cl9wq5dcl32n3q67lr2qsb6y3giz335hx'';
  };
    
  packageName = "fast-http";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/fast-http[.]asd${"$"}' |
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
/* (SYSTEM fast-http DESCRIPTION A fast HTTP protocol parser in Common Lisp SHA256 0kpfn4i5r12hfnb3j00cl9wq5dcl32n3q67lr2qsb6y3giz335hx URL
    http://beta.quicklisp.org/archive/fast-http/2017-02-27/fast-http-20170227-git.tgz MD5 5c5e2073702e7504a30c739e25c47c69 NAME fast-http TESTNAME NIL FILENAME
    fast-http DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS (fast-http-test)) */
