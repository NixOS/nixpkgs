args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unification'';
  version = ''20170124-git'';

  description = ''The CL-UNIFICATION system.

The system contains the definitions for the 'unification' machinery.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unification/2017-01-24/cl-unification-20170124-git.tgz'';
    sha256 = ''0gwk40y5byg6q0hhd41rqf8g8i1my0h4lshc63xfnh3mfgcc8bx9'';
  };

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
    SHA256 0gwk40y5byg6q0hhd41rqf8g8i1my0h4lshc63xfnh3mfgcc8bx9 URL http://beta.quicklisp.org/archive/cl-unification/2017-01-24/cl-unification-20170124-git.tgz
    MD5 dd277adaf3a0ee41fd0731f78519b1b1 NAME cl-unification TESTNAME NIL FILENAME cl-unification DEPS NIL DEPENDENCIES NIL VERSION 20170124-git SIBLINGS
    (cl-unification-lib cl-unification-test cl-ppcre-template)) */
