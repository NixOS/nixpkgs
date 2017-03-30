args @ { fetchurl, ... }:
rec {
  baseName = ''cl-annot'';
  version = ''20150608-git'';

  description = ''Python-like Annotation Syntax for Common Lisp'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-annot/2015-06-08/cl-annot-20150608-git.tgz'';
    sha256 = ''0ixsp20rk498phv3iivipn3qbw7a7x260x63hc6kpv2s746lpdg3'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-annot)"' "$out/bin/cl-annot-lisp-launcher.sh" ""
    '';
  };
}
