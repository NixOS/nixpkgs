args @ { fetchurl, ... }:
rec {
  baseName = ''cl-libuv'';
  version = ''20160825-git'';

  description = ''Low-level libuv bindings for Common Lisp.'';

  deps = [ args."alexandria" args."cffi" args."cffi-grovel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-libuv/2016-08-25/cl-libuv-20160825-git.tgz'';
    sha256 = ''02vi9ph9pxbxgp9jsbgzb9nijsv0vyk3f1jyhhm88i0y1kb3595r'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-libuv)"' "$out/bin/cl-libuv-lisp-launcher.sh" ""
    '';
  };
}
