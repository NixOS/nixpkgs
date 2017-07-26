args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unification'';
  version = ''20170516-git'';

  description = ''The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-05-16/cl-unification-20170516-git.tgz'';
    sha256 = ''0yg2i0vn11skfz0b1zc8wnsqr24gf7fc4hzmwrwj15iz3xzqy9b0'';
  };
    
  packageName = "cl-unification";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-unification[.]asd${"$"}' |
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
/* (SYSTEM cl-unification DESCRIPTION The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.
    SHA256 0yg2i0vn11skfz0b1zc8wnsqr24gf7fc4hzmwrwj15iz3xzqy9b0 URL http://beta.quicklisp.org/archive/cl-unification/2017-05-16/cl-unification-20170516-git.tgz
    MD5 70bcdd486f3444ddd41b5c2c3add119c NAME cl-unification TESTNAME NIL FILENAME cl-unification DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS
    (cl-unification-lib cl-unification-test cl-ppcre-template)) */
