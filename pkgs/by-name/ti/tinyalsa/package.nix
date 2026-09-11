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
  version = "2.0.0-unstable-2026-07-27";

  src = fetchFromGitHub {
    owner = "tinyalsa";
    repo = "tinyalsa";
    rev = "9fab97ca07184371ecad81154d1dadb09d0fa7cf";
    hash = "sha256-+/wz0pwyF1kulUA5kjFGVOwbSkunEU+WzsZf/UsCEVk=";
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
