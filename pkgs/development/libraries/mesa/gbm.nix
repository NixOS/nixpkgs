{
  lib,
  stdenv,
  fetchFromGitLab,
  libglvnd,
  bison,
  flex,
  meson,
  pkg-config,
  ninja,
  python3Packages,
  libdrm,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitLab; };
in
stdenv.mkDerivation {
  pname = "mesa-libgbm";
  inherit (common) version src meta;

  mesonAutoFeatures = "disabled";

  mesonFlags = [
    "--sysconfdir=/etc"

    (lib.mesonEnable "gbm" true)
    (lib.mesonOption "gbm-backends-path" "${libglvnd.driverLink}/lib/gbm")

    (lib.mesonEnable "egl" false)
    (lib.mesonEnable "glx" false)
    (lib.mesonEnable "zlib" false)

    (lib.mesonOption "platforms" "")
    (lib.mesonOption "gallium-drivers" "")
    (lib.mesonOption "vulkan-drivers" "")
    (lib.mesonOption "vulkan-layers" "")
  ];

  strictDeps = true;

  propagatedBuildInputs = [ libdrm ];

  nativeBuildInputs = [
    bison
    flex
    meson
    pkg-config
    ninja
    python3Packages.packaging
    python3Packages.python
    python3Packages.mako
    python3Packages.pyyaml
  ];
}
