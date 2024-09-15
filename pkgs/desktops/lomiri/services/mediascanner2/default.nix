{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, testers
, boost
, cmake
, cmake-extras
, dbus
, dbus-cpp
, gdk-pixbuf
, glib
, gst_all_1
, gtest
, libapparmor
, libexif
, pkg-config
, properties-cpp
, qtbase
, qtdeclarative
, shared-mime-info
, sqlite
, taglib
, udisks
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mediascanner2";
  version = "0.115";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/mediascanner2";
    rev = finalAttrs.version;
    hash = "sha256-UEwFe65VB2asxQhuWGEAVow/9rEvZxry4dd2/60fXN4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace src/qml/MediaScanner.*/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Lomiri desktop doesn't identify itself under Canonical's name anymore
    substituteInPlace src/daemon/scannerdaemon.cc \
      --replace 'Unity8' 'Lomiri'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gst_all_1.gstreamer # GST_PLUGIN_SYSTEM_PATH_1_0 setup hook
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
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
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.finalPackage.doCheck}"
  ];

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

  meta = with lib; {
    description = "Media scanner service & access library";
    homepage = "https://gitlab.com/ubports/development/core/mediascanner2";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    mainProgram = "mediascanner-service-2.0";
    platforms = platforms.linux;
    pkgConfigModules = [
      "mediascanner-2.0"
    ];
  };
})
