args @ { fetchurl, ... }:
rec {
  baseName = ''cl-emb'';
  version = ''20170227-git'';

  description = ''A templating system for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-emb/2017-02-27/cl-emb-20170227-git.tgz'';
    sha256 = ''03n97xvh3v8bz1p75v1vhryfkjm74v0cr5jwg4rakq9zkchhfk80'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-emb)"' "$out/bin/cl-emb-lisp-launcher.sh" ""
    '';
  };
}
