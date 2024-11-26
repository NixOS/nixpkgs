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
  Xplugin,
  xorg,
  zlib,
}:
let
  common = import ./common.nix { inherit lib fetchFromGitLab; };
in stdenv.mkDerivation {
  inherit (common) pname version src meta;

  patches = [
    ./darwin-build-fix.patch
  ];

  outputs = [ "out" "dev" ];

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
    libxml2  # should be propagated from libllvm
    llvmPackages.libllvm
    Xplugin
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
    zlib
  ];

  mesonAutoFeatures = "disabled";

  mesonFlags = [
    "--sysconfdir=/etc"
    "--datadir=${placeholder "out"}/share"
    (lib.mesonEnable "glvnd" false)
    (lib.mesonEnable "shared-glapi" true)
    (lib.mesonEnable "llvm" true)
  ];

  # Don't need this on Darwin.
  passthru.llvmpipeHook = null;
}
