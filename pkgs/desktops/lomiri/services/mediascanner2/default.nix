{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  testers,
  # dbus-cpp not compatible with Boost 1.87
  # https://gitlab.com/ubports/development/core/lib-cpp/dbus-cpp/-/issues/8
  boost186,
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
  version = "0.118";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/mediascanner2";
    tag = finalAttrs.version;
    hash = "sha256-ZJXJNDZUDor5EJ+rn7pQt7lLzoszZUQM3B+u1gBSMs8=";
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

  buildInputs = [
    boost186
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
    tests = {
      # music app needs mediascanner to work properly, so it can find files
      music-app = nixosTests.lomiri-music-app;

      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Media scanner service & access library";
    homepage = "https://gitlab.com/ubports/development/core/mediascanner2";
    changelog = "https://gitlab.com/ubports/development/core/mediascanner2/-/blob/${
      if (!builtins.isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    mainProgram = "mediascanner-service-2.0";
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "mediascanner-2.0" ];
  };
})
