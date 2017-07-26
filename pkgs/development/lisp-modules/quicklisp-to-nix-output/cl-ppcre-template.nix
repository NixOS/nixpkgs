args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-template'';
  version = ''cl-unification-20170516-git'';

  description = ''A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-05-16/cl-unification-20170516-git.tgz'';
    sha256 = ''0yg2i0vn11skfz0b1zc8wnsqr24gf7fc4hzmwrwj15iz3xzqy9b0'';
  };
    
  packageName = "cl-ppcre-template";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-ppcre-template[.]asd${"$"}' |
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
/* (SYSTEM cl-ppcre-template DESCRIPTION A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.
    SHA256 0yg2i0vn11skfz0b1zc8wnsqr24gf7fc4hzmwrwj15iz3xzqy9b0 URL http://beta.quicklisp.org/archive/cl-unification/2017-05-16/cl-unification-20170516-git.tgz
    MD5 70bcdd486f3444ddd41b5c2c3add119c NAME cl-ppcre-template TESTNAME NIL FILENAME cl-ppcre-template DEPS NIL DEPENDENCIES NIL VERSION
    cl-unification-20170516-git SIBLINGS (cl-unification-lib cl-unification-test cl-unification)) */
