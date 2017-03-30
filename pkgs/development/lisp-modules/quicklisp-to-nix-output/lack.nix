args @ { fetchurl, ... }:
rec {
  baseName = ''lack'';
  version = ''20161204-git'';

  description = ''A minimal Clack'';

  deps = [ args."lack-component" args."lack-util" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2016-12-04/lack-20161204-git.tgz'';
    sha256 = ''10bnpgbh5nk9lw1xywmvh5661rq91v8sp43ds53x98865ni7flnv'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :lack)"' "$out/bin/lack-lisp-launcher.sh" ""
    '';
  };
}
