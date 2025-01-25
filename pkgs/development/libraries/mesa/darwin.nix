# The Darwin build of Mesa is different enough that we just give it an entire separate expression.
{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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
in
stdenv.mkDerivation {
  inherit (common)
    pname
    version
    src
    meta
    ;

  # Darwin build fixes. FIXME: remove in 25.1.
  patches = [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/mesa/mesa/-/commit/e89eba0796b3469f1d2cdbb600309f6231a8169d.patch";
      hash = "sha256-0EP0JsYy+UTQ+eGd3sMfoLf1R+2e8n1flmQAHq3rCR4=";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/mesa/mesa/-/commit/568a4ca899762fe96fc9b34d2288d07e6656af87.patch";
      hash = "sha256-uLxa5vA3/cYAIJT9h7eBQ1EBu4MnMg9R5uGAHzTb5Fc=";
    })
  ];

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

  passthru = {
    # needed to pass evaluation of bad platforms
    driverLink = throw "driverLink not supported on darwin";
    # Don't need this on Darwin.
    llvmpipeHook = null;
  };

}
