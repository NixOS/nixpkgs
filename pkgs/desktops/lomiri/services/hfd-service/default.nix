{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, cmake
, cmake-extras
, deviceinfo
, libgbinder
, libglibutil
, pkg-config
, qtbase
, qtdeclarative
, qtfeedback
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hfd-service";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/hfd-service";
    rev = finalAttrs.version;
    hash = "sha256-F1MLYcCYe2GAPNO3UuONM4/j9AnV+V2YgePBn2QY5zM=";
  };

  postPatch = ''
    substituteInPlace qt/feedback-plugin/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/plugins" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtPluginPrefix}"

    # Queries pkg-config via pkg_get_variable, can't override prefix
    substituteInPlace init/CMakeLists.txt \
      --replace "\''${SYSTEMD_SYSTEM_DIR}" "$out/lib/systemd/system"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    deviceinfo
    libgbinder
    libglibutil
    qtbase
    qtdeclarative
    qtfeedback
  ];

  cmakeFlags = [
    "-DENABLE_LIBHYBRIS=OFF"
  ];

  dontWrapQtApps = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "DBus-activated service that manages human feedback devices such as LEDs and vibrators on mobile devices";
    homepage = "https://gitlab.com/ubports/development/core/hfd-service";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
