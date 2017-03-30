args @ { fetchurl, ... }:
rec {
  baseName = ''rfc2388'';
  version = ''20130720-git'';

  description = ''Implementation of RFC 2388'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/rfc2388/2013-07-20/rfc2388-20130720-git.tgz'';
    sha256 = ''1ky99cr4bgfyh0pfpl5f6fsmq1qdbgi4b8v0cfs4y73f78p1f8b6'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :rfc2388)"' "$out/bin/rfc2388-lisp-launcher.sh" ""
    '';
  };
}
