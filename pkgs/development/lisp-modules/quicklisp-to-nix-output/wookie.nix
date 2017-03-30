args @ { fetchurl, ... }:
rec {
  baseName = ''wookie'';
  version = ''20170227-git'';

  description = ''An evented webserver for Common Lisp.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/wookie/2017-02-27/wookie-20170227-git.tgz'';
    sha256 = ''0i1wrgr5grg387ldv1zfswws1g3xvrkxxvp1m58m9hj0c1vmm6v0'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :wookie)"' "$out/bin/wookie-lisp-launcher.sh" ""
    '';
  };
}
