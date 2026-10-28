{
  lib,
  stdenv,
  testers,
  unstableGitUpdater,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyalsa";
  version = "2.0.0-unstable-2026-10-14";

  src = fetchFromGitHub {
    owner = "tinyalsa";
    repo = "tinyalsa";
    rev = "bbdba1e208f402c5b7d5cb3d42307a3db9f6bb1c";
    hash = "sha256-WREUx5QCNsY0ovuwVDrJzuNWQFYzKP6n7+QTTiGlLLY=";
  };

  separateDebugInfo = true;
  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = false;
    };
  };

  meta = {
    homepage = "https://github.com/tinyalsa/tinyalsa";
    description = "Tiny library to interface with ALSA in the Linux kernel";
    license = lib.licenses.mit;
    pkgConfigModules = [ "tinyalsa" ];
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = with lib.platforms; linux;
  };
})
