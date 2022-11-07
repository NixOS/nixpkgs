{ pkgs, ... }:

let

  # TODO(kasper): precompile asdf.lisp per implementation?
  defaultAsdf = pkgs.stdenv.mkDerivation rec {
    pname = "asdf";
    version = "3.3.5.11";
    src = pkgs.fetchzip {
      url = "https://gitlab.common-lisp.net/asdf/asdf/-/archive/${version}/asdf-${version}.tar.gz";
      hash = "sha256-SGzuSP2A168JafG4GYiTOCVLA1anhOB9uZThO8Speik";
    };
    installPhase = ''
      cp build/asdf.lisp $out
    '';
  };

in pkgs.callPackage (import ./nix-cl.nix {
  inherit defaultAsdf;
}) {
  inherit pkgs;
}
