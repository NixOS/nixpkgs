args @ { fetchurl, ... }:
rec {
  baseName = ''command-line-arguments'';
  version = ''20151218-git'';

  description = ''small library to deal with command-line arguments'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz'';
    sha256 = ''07yv3vj9kjd84q09d6kvgryqxb71bsa7jl22fd1an6inmk0a3yyh'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :command-line-arguments)"' "$out/bin/command-line-arguments-lisp-launcher.sh" ""
    '';
  };
}
