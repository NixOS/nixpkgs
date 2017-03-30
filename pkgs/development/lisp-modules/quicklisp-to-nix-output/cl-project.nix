args @ { fetchurl, ... }:
rec {
  baseName = ''cl-project'';
  version = ''20160531-git'';

  description = ''Generate a skeleton for modern project'';

  deps = [ args."cl-emb" args."cl-ppcre" args."local-time" args."prove" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-project/2016-05-31/cl-project-20160531-git.tgz'';
    sha256 = ''1xwjgs5pzkdnd9i5lcic9z41d1c4yf7pvarrvawfxcicg6rrfw81'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-project)"' "$out/bin/cl-project-lisp-launcher.sh" ""
    '';
  };
}
