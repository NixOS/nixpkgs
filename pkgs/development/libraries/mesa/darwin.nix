# The Darwin build of Mesa is different enough that we just give it an entire separate expression.
{
  lib,
  stdenv,
  fetchFromGitLab,
  bison,
  flex,
  libxml2,
  llvmPackages,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  xorg,
  zlib,
}:
let
  common = import ./common.nix { inherit lib fetchFromGitLab; };
in
stdenv.mkDerivation {
  inherit (common)
    pname
    version
    src
    meta
    ;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    bison
    flex
    meson
    ninja
    pkg-config
    python3Packages.packaging
    python3Packages.python
    python3Packages.mako
    python3Packages.pyyaml
  ];

  buildInputs = [
    libxml2 # should be propagated from libllvm
    llvmPackages.libllvm
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
    xorg.libxcb
    zlib
  ];

  mesonAutoFeatures = "disabled";

  mesonFlags = [
    "--sysconfdir=/etc"
    "--datadir=${placeholder "out"}/share"
    (lib.mesonEnable "glvnd" false)
    (lib.mesonEnable "llvm" true)
  ];

  passthru = {
    # needed to pass evaluation of bad platforms
    driverLink = throw "driverLink not supported on darwin";
    # Don't need this on Darwin.
    llvmpipeHook = null;
  };

}
