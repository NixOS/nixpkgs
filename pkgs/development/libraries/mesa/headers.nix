{
  lib,
  stdenv,
  fetchFromGitLab,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitLab; };
  headers = [
    "include/EGL/eglext_angle.h"
    "include/EGL/eglmesaext.h"
  ];
in
stdenv.mkDerivation rec {
  pname = "mesa-gl-headers";

  # These are a bigger rebuild and don't change often, so keep them separate.
  version = "25.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "mesa";
    rev = "mesa-${version}";
    hash = "sha256-9D4d7EEdZysvXDRcmpbyt85Lo64sldNRomp6/HUVORo=";
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
