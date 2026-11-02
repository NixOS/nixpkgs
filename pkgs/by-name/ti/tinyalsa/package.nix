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
  version = "2.0.0-unstable-2026-10-23";

  src = fetchFromGitHub {
    owner = "tinyalsa";
    repo = "tinyalsa";
    rev = "a7cd26a17fe2add2ff38d2f281ed0b919187a068";
    hash = "sha256-B2u9xjH3oHb5zrQyyKVUK86hx1Voq+AxdVP4n9ZYerg=";
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
