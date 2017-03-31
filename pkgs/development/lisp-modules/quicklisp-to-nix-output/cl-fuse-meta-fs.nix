args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse-meta-fs'';
  version = ''20150608-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."bordeaux-threads" args."cl-fuse" args."iterate" args."pcall" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse-meta-fs/2015-06-08/cl-fuse-meta-fs-20150608-git.tgz'';
    sha256 = ''1i3yw237ygwlkhbcbm9q54ad9g4fi63fw4mg508hr7bz9gzg36q2'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-fuse-meta-fs)"' "$out/bin/cl-fuse-meta-fs-lisp-launcher.sh" ""
    '';
  };
}
