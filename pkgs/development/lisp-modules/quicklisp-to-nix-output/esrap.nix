args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20170124-git'';

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2017-01-24/esrap-20170124-git.tgz'';
    sha256 = ''1182011bbhvkw2qsdqrccl879vf5k7bcda318n0xskk35hzircp8'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :esrap)"' "$out/bin/esrap-lisp-launcher.sh" ""
    '';
  };
}
