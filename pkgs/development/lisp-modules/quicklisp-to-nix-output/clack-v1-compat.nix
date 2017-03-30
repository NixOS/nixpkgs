args @ { fetchurl, ... }:
rec {
  baseName = ''clack-v1-compat'';
  version = ''clack-20170227-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-02-27/clack-20170227-git.tgz'';
    sha256 = ''1sm6iamghpzmrv0h375y2famdngx62ml5dw424896kixxfyr923x'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :clack-v1-compat)"' "$out/bin/clack-v1-compat-lisp-launcher.sh" ""
    '';
  };
}
