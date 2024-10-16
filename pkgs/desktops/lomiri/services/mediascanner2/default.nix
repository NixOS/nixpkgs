{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  boost,
  cmake,
  cmake-extras,
  dbus,
  dbus-cpp,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtest,
  libapparmor,
  libexif,
  pkg-config,
  properties-cpp,
  qtbase,
  qtdeclarative,
  shared-mime-info,
  sqlite,
  taglib,
  udisks,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mediascanner2";
  version = "0.117";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/mediascanner2";
    rev = finalAttrs.version;
    hash = "sha256-e1vDPnIIfevXj9ODEEKJ2y4TiU0H+08aTf2vU+emdQk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace src/qml/MediaScanner.*/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gst_all_1.gstreamer # GST_PLUGIN_SYSTEM_PATH_1_0 setup hook
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs =
    [
      boost
      cmake-extras
      dbus
      dbus-cpp
      gdk-pixbuf
      glib
      libapparmor
      libexif
      properties-cpp
      qtbase
      qtdeclarative
      shared-mime-info
      sqlite
      taglib
      udisks
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ]);

  checkInputs = [ gtest ];

  cmakeFlags = [ (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck) ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export XDG_DATA_DIRS=${shared-mime-info}/share:$XDG_DATA_DIRS
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix XDG_DATA_DIRS : ${shared-mime-info}/share
    )
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Media scanner service & access library";
    homepage = "https://gitlab.com/ubports/development/core/mediascanner2";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    mainProgram = "mediascanner-service-2.0";
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "mediascanner-2.0" ];
  };
})
