args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse'';
  version = ''20160318-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cl-utilities" args."iterate" args."trivial-backtrace" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse/2016-03-18/cl-fuse-20160318-git.tgz'';
    sha256 = ''1yllmnnhqp42s37a2y7h7vph854xgna62l1pidvlyskc90bl5jf6'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-fuse)"' "$out/bin/cl-fuse-lisp-launcher.sh" ""
    '';
  };
}
