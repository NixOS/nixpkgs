args @ { fetchurl, ... }:
rec {
  baseName = ''cl-colors'';
  version = ''20151218-git'';

  description = ''Simple color library for Common Lisp'';

  deps = [ args."alexandria" args."let-plus" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-colors/2015-12-18/cl-colors-20151218-git.tgz'';
    sha256 = ''032kswn6h2ib7v8v1dg0lmgfks7zk52wrv31q6p2zj2a156ccqp4'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-colors)"' "$out/bin/cl-colors-lisp-launcher.sh" ""
    '';
  };
}
