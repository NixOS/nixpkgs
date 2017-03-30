args @ { fetchurl, ... }:
rec {
  baseName = ''fast-http'';
  version = ''20170227-git'';

  description = ''A fast HTTP protocol parser in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-http/2017-02-27/fast-http-20170227-git.tgz'';
    sha256 = ''0kpfn4i5r12hfnb3j00cl9wq5dcl32n3q67lr2qsb6y3giz335hx'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :fast-http)"' "$out/bin/fast-http-lisp-launcher.sh" ""
    '';
  };
}
