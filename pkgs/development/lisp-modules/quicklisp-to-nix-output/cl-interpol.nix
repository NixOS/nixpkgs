args @ { fetchurl, ... }:
rec {
  baseName = ''cl-interpol'';
  version = ''0.2.6'';

  description = '''';

  deps = [ args."cl-unicode" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-interpol/2016-09-29/cl-interpol-0.2.6.tgz'';
    sha256 = ''172iy4bp4fxyfhz7n6jbqz4j8xqnzpvmh981bbi5waflg58x9h8b'';
  };
    
  packageName = "cl-interpol";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-interpol[.]asd${"$"}' |
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
/* (SYSTEM cl-interpol DESCRIPTION NIL SHA256 172iy4bp4fxyfhz7n6jbqz4j8xqnzpvmh981bbi5waflg58x9h8b URL
    http://beta.quicklisp.org/archive/cl-interpol/2016-09-29/cl-interpol-0.2.6.tgz MD5 1adc92924670601ebb92546ef8bdc6a7 NAME cl-interpol TESTNAME NIL FILENAME
    cl-interpol DEPS ((NAME cl-unicode FILENAME cl-unicode)) DEPENDENCIES (cl-unicode) VERSION 0.2.6 SIBLINGS NIL) */
