{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, testers
, cmake
, cmake-extras
, glib
, gobject-introspection
, gtest
, intltool
, pkg-config
, systemd
, vala
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libayatana-common";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-common";
    rev = finalAttrs.version;
    hash = "sha256-IBLJPgi+dKZKbR0Yjr2aNjCdpY+PE1k9QLSsk++6Wqo=";
  };

  postPatch = ''
    # Queries via pkg_get_variable, can't override prefix
    substituteInPlace data/CMakeLists.txt \
      --replace 'DESTINATION "''${SYSTEMD_USER_UNIT_DIR}"' 'DESTINATION "${placeholder "out"}/lib/systemd/user"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gobject-introspection
    intltool
    pkg-config
    vala
  ];

  buildInputs = [
    cmake-extras
    glib
    systemd
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.doCheck}"
    "-DENABLE_LOMIRI_FEATURES=OFF"
    "-DGSETTINGS_LOCALINSTALL=ON"
    "-DGSETTINGS_COMPILE=ON"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Common functions for Ayatana System Indicators";
    homepage = "https://github.com/AyatanaIndicators/libayatana-common";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
    pkgConfigModules = [
      "libayatana-common"
    ];
  };
})
