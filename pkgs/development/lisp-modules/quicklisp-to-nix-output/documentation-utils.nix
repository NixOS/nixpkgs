args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20161204-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2016-12-04/documentation-utils-20161204-git.tgz'';
    sha256 = ''0vyj5nvy697w2fvp2rb42jxgqah85ivz1hg84amqfi4bvik2npvq'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :documentation-utils)"' "$out/bin/documentation-utils-lisp-launcher.sh" ""
    '';
  };
}
