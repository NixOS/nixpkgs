args @ { fetchurl, ... }:
rec {
  baseName = ''woo'';
  version = ''20170227-git'';

  description = ''An asynchronous HTTP server written in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/woo/2017-02-27/woo-20170227-git.tgz'';
    sha256 = ''0myydz817mpkgs97p9y9n4z0kq00xxr2b65klsdkxasvvfyjw0d1'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :woo)"' "$out/bin/woo-lisp-launcher.sh" ""
    '';
  };
}
