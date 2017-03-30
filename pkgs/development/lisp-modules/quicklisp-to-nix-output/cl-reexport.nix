args @ { fetchurl, ... }:
rec {
  baseName = ''cl-reexport'';
  version = ''20150709-git'';

  description = ''Reexport external symbols in other packages.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-reexport/2015-07-09/cl-reexport-20150709-git.tgz'';
    sha256 = ''1y6qlyps7g0wl4rbmzvw6s1kjdwwmh33layyjclsjp9j5nm8mdmi'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-reexport)"' "$out/bin/cl-reexport-lisp-launcher.sh" ""
    '';
  };
}
