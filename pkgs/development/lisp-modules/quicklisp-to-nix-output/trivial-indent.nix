args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20160929-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2016-09-29/trivial-indent-20160929-git.tgz'';
    sha256 = ''0nc7d5xdx4h8jvvqif7f721z8296kl6jk5hqmgr0mj3g7svgfrir'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :trivial-indent)"' "$out/bin/trivial-indent-lisp-launcher.sh" ""
    '';
  };
}
