args @ { fetchurl, ... }:
rec {
  baseName = ''prove'';
  version = ''20170124-git'';

  description = '''';

  deps = [ args."alexandria" args."cl-ansi-text" args."cl-colors" args."cl-ppcre" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-01-24/prove-20170124-git.tgz'';
    sha256 = ''1kyhh4yvf47psb5v0zqivcwn71n6my5fwggdifymlpigk2q3zn03'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :prove)"' "$out/bin/prove-lisp-launcher.sh" ""
    '';
  };
}
