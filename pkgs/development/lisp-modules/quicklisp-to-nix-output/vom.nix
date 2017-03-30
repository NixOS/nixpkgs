args @ { fetchurl, ... }:
rec {
  baseName = ''vom'';
  version = ''20160825-git'';

  description = ''A tiny logging utility.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/vom/2016-08-25/vom-20160825-git.tgz'';
    sha256 = ''0mvln0xx8qnrsmaj7c0f2ilgahvf078qvhqag7qs3j26xmamjm93'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :vom)"' "$out/bin/vom-lisp-launcher.sh" ""
    '';
  };
}
