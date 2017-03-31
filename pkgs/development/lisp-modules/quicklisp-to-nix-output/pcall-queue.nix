args @ { fetchurl, ... }:
rec {
  baseName = ''pcall-queue'';
  version = ''pcall-0.3'';

  description = '''';

  deps = [ args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/pcall/2010-10-06/pcall-0.3.tgz'';
    sha256 = ''02idx1wnv9770fl2nh179sb8njw801g70b5mf8jqhqm2gwsb731y'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :pcall-queue)"' "$out/bin/pcall-queue-lisp-launcher.sh" ""
    '';
  };
}
