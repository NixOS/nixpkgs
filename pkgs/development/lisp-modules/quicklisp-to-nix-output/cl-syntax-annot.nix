args @ { fetchurl, ... }:
rec {
  baseName = ''cl-syntax-annot'';
  version = ''cl-syntax-20150407-git'';

  description = ''CL-Syntax Reader Syntax for cl-annot'';

  deps = [ args."cl-annot" args."cl-syntax" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz'';
    sha256 = ''1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-syntax-annot)"' "$out/bin/cl-syntax-annot-lisp-launcher.sh" ""
    '';
  };
}
