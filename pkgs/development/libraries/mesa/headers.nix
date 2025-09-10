{
  lib,
  stdenv,
  fetchFromGitLab,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitLab; };
  headers = [
    "include/GL/internal/dri_interface.h"
    "include/EGL/eglext_angle.h"
    "include/EGL/eglmesaext.h"
  ];
in
stdenv.mkDerivation rec {
  pname = "mesa-gl-headers";

  # These are a bigger rebuild and don't change often, so keep them separate.
  version = "25.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "mesa";
    rev = "mesa-${version}";
    hash = "sha256-UlI+6OMUj5F6uVAw+Mg2wOZrjfdRq73d1qufaXVI/go";
  };

  dontBuild = true;

  installPhase = ''
    for header in ${toString headers}; do
      install -Dm444 $header $out/$header
    done
  '';

  passthru = { inherit headers; };

  inherit (common) meta;
}
