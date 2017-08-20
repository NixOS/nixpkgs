args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-template'';
  version = ''cl-unification-20170630-git'';

  description = ''A system used to conditionally load the CL-PPCRE Template.

This system is not required and it is handled only if CL-PPCRE is
available.  If it is, then the library provides the
REGULAR-EXPRESSION-TEMPLATE.'';

  deps = [ args."cl-ppcre" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-06-30/cl-unification-20170630-git.tgz'';
    sha256 = ''063xcf2ib3gdpjr39bgkaj6msylzdhbdjsj458w08iyidbxivwlz'';
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
    SHA256 063xcf2ib3gdpjr39bgkaj6msylzdhbdjsj458w08iyidbxivwlz URL http://beta.quicklisp.org/archive/cl-unification/2017-06-30/cl-unification-20170630-git.tgz
    MD5 f6bf197ca8c79c935efe3a3c25953044 NAME cl-ppcre-template TESTNAME NIL FILENAME cl-ppcre-template DEPS ((NAME cl-ppcre FILENAME cl-ppcre)) DEPENDENCIES
    (cl-ppcre) VERSION cl-unification-20170630-git SIBLINGS (cl-unification-lib cl-unification-test cl-unification)) */
