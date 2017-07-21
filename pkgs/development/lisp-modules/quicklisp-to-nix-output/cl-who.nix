args @ { fetchurl, ... }:
rec {
  baseName = ''cl-who'';
  version = ''1.1.4'';

  description = ''(X)HTML generation macros'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-who/2014-12-17/cl-who-1.1.4.tgz'';
    sha256 = ''0r9wc92njz1cc7nghgbhdmd7jy216ylhlabfj0vc45bmfa4w44rq'';
  };
    
  packageName = "cl-who";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-who[.]asd${"$"}' |
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
/* (SYSTEM cl-who DESCRIPTION (X)HTML generation macros SHA256 0r9wc92njz1cc7nghgbhdmd7jy216ylhlabfj0vc45bmfa4w44rq URL
    http://beta.quicklisp.org/archive/cl-who/2014-12-17/cl-who-1.1.4.tgz MD5 a9e6f0b6a8aaa247dbf751de2cb550bf NAME cl-who TESTNAME NIL FILENAME cl-who DEPS NIL
    DEPENDENCIES NIL VERSION 1.1.4 SIBLINGS NIL) */
