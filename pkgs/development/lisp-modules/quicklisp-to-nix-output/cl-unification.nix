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
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-unification)"' "$out/bin/cl-unification-lisp-launcher.sh" ""
    '';
  };
}
