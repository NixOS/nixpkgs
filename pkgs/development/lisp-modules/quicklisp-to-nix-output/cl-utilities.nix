args @ { fetchurl, ... }:
rec {
  baseName = ''cl-utilities'';
  version = ''1.2.4'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz'';
    sha256 = ''1z2ippnv2wgyxpz15zpif7j7sp1r20fkjhm4n6am2fyp6a3k3a87'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-utilities)"' "$out/bin/cl-utilities-lisp-launcher.sh" ""
    '';
  };
}
