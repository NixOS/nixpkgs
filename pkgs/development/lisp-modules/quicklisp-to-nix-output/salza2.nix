args @ { fetchurl, ... }:
rec {
  baseName = ''salza2'';
  version = ''2.0.9'';

  description = ''Create compressed data in the ZLIB, DEFLATE, or GZIP
  data formats'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz'';
    sha256 = ''1m0hksgvq3njd9xa2nxlm161vgzw77djxmisq08v9pz2bz16v8va'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :salza2)"' "$out/bin/salza2-lisp-launcher.sh" ""
    '';
  };
}
