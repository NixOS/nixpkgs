args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fad'';
  version = ''0.7.4'';

  description = ''Portable pathname library'';

  deps = [ args."alexandria" args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fad/2016-08-25/cl-fad-0.7.4.tgz'';
    sha256 = ''1avp5j66vrpv5symgw4n4szlc2cyqz4haa0cxzy1pl8p0a8k0v9x'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-fad)"' "$out/bin/cl-fad-lisp-launcher.sh" ""
    '';
  };
}
