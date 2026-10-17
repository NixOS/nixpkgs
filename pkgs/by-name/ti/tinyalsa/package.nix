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
  version = "2.0.0-unstable-2026-09-29";

  src = fetchFromGitHub {
    owner = "tinyalsa";
    repo = "tinyalsa";
    rev = "961babfe962e71d952ae734074cc89576b28a9e7";
    hash = "sha256-esuw40BFAKjYhLigflTWQoixcZkQ0e/Mc1UO/pNE05E=";
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
