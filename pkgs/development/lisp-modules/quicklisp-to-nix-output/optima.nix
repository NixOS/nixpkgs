args @ { fetchurl, ... }:
rec {
  baseName = ''optima'';
  version = ''20150709-git'';

  description = ''Optimized Pattern Matching Library'';

  deps = [ args."alexandria" args."closer-mop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/optima/2015-07-09/optima-20150709-git.tgz'';
    sha256 = ''0vqyqrnx2d8qwa2jlg9l2wn6vrykraj8a1ysz0gxxxnwpqc29hdc'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :optima)"' "$out/bin/optima-lisp-launcher.sh" ""
    '';
  };
}
