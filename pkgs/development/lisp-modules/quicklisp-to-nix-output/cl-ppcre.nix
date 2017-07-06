args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre'';
  version = ''2.0.11'';

  description = ''Perl-compatible regular expression library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz'';
    sha256 = ''1djciws9n0jg3qdrck3j4wj607zvkbir8p379mp0p7b5g0glwvb2'';
  };
    
  packageName = "cl-ppcre";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-ppcre[.]asd${"$"}' |
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
/* (SYSTEM cl-ppcre DESCRIPTION Perl-compatible regular expression library SHA256 1djciws9n0jg3qdrck3j4wj607zvkbir8p379mp0p7b5g0glwvb2 URL
    http://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz MD5 6d5250467c05eb661a76d395186a1da0 NAME cl-ppcre TESTNAME NIL FILENAME cl-ppcre
    DEPS NIL DEPENDENCIES NIL VERSION 2.0.11 SIBLINGS (cl-ppcre-unicode)) */
