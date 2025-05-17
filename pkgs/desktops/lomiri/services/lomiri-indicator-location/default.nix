{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  cmake,
  dbus,
  gettext,
  glib,
  gtest,
  lomiri-app-launch,
  lomiri-url-dispatcher,
  pkg-config,
  properties-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-location";
  version = "25.2.7";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-indicator-location";
    tag = finalAttrs.version;
    hash = "sha256-h7OydajP1b6HNd3pX6ypMGXyVr0MZavUOwmFdfe4LbE=";
  };

  patches = [
    # Remove when version > 25.2.7
    (fetchpatch {
      name = "0001-lomiri-indicator-location-ayatana-namespace.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-indicator-location/-/commit/1addd53f49215d1004e2d392b79f91d270603792.patch";
      hash = "sha256-GHnRbylfjhdz49FeRfSZEwsBwjCab9c4QY4V4h1VIl0=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-indicator-location/-/merge_requests/33 merged & in release
    ./1001-CMakeLists.txt-Use-system-provided-gtest.patch
  ];

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace-fail '/etc' "$out/etc" \
      --replace-fail '/usr' "$out"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    glib
    lomiri-app-launch
    lomiri-url-dispatcher
    properties-cpp
  ];

  nativeCheckInputs = [
    dbus
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "enable_tests" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "enable_lcov" false)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Involves D-Bus
  enableParallelChecking = false;

  passthru = {
    ayatana-indicators = {
      lomiri-indicator-location = [ "lomiri" ];
    };
    tests = {
      vm = nixosTests.ayatana-indicators;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Indicator controlling access to physical location data";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-indicator-location";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-indicator-location/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
