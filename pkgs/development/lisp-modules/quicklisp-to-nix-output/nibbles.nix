args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20161204-git'';

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2016-12-04/nibbles-20161204-git.tgz'';
    sha256 = ''06cdnivq2966crpj8pidqmwagaif848yvq4fjqq213f3wynwknh4'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :nibbles)"' "$out/bin/nibbles-lisp-launcher.sh" ""
    '';
  };
}
