args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20160929-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2016-09-29/array-utils-20160929-git.tgz'';
    sha256 = ''1nlrf7b81qq7l85kkdh3fxcs6ngnvh5zk7mb5mwf8vjm5kpfbbcx'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :array-utils)"' "$out/bin/array-utils-lisp-launcher.sh" ""
    '';
  };
}
