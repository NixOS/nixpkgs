args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20170227-git'';

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2017-02-27/clx-20170227-git.tgz'';
    sha256 = ''0zgp1yqy0lm528bhil93ap7df01qdyfhnbxhckjv87xk8rs0g5nx'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clx[.]asd${"$"}' |
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
/* (SYSTEM clx DESCRIPTION An implementation of the X Window System protocol in Lisp. SHA256 0zgp1yqy0lm528bhil93ap7df01qdyfhnbxhckjv87xk8rs0g5nx URL
    http://beta.quicklisp.org/archive/clx/2017-02-27/clx-20170227-git.tgz MD5 fe5fc4bd65ced7a0164abc0ed34afffd NAME clx TESTNAME NIL FILENAME clx DEPS NIL
    DEPENDENCIES NIL VERSION 20170227-git SIBLINGS NIL) */
