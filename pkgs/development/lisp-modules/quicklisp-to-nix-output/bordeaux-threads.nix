args @ { fetchurl, ... }:
rec {
  baseName = ''bordeaux-threads'';
  version = ''v0.8.5'';

  description = ''Bordeaux Threads makes writing portable multi-threaded apps simple.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/bordeaux-threads/2016-03-18/bordeaux-threads-v0.8.5.tgz'';
    sha256 = ''09q1xd3fca6ln6mh45cx24xzkrcnvhgl5nn9g2jv0rwj1m2xvbpd'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :bordeaux-threads)"' "$out/bin/bordeaux-threads-lisp-launcher.sh" ""
    '';
  };
}
