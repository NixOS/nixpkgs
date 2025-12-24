{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  glib,
  libglvnd,
  pkg-config,
  qtbase,
  qtdeclarative,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gsettings-qt";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/gsettings-qt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NUrJ3xQnef7TwPa7AIZaiI7TAkMe+nhuEQ/qC1H1Ves=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative
  ];

  buildInputs = [
    cmake-extras
    glib
  ]
  ++ lib.optionals withQt6 [
    libglvnd
  ];

  # Library
  dontWrapQtApps = true;

  postPatch =
    # Upstream renamed WERROR option to ENABLE_WERROR, but forgot this line
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'if (WERROR)' 'if (ENABLE_WERROR)'
    ''
    # The usual pkg-config fix
    + ''
      substituteInPlace src/gsettings-qt.pc.in \
        --replace-fail "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" '@CMAKE_INSTALL_FULL_LIBDIR@' \
        --replace-fail "\''${prefix}/@QT_INCLUDE_DIR@/QGSettings" '@QT_FULL_INCLUDE_DIR@/QGSettings'
    ''
    # Adjust to where we keep QML modules
    + ''
      substituteInPlace GSettings/CMakeLists.txt \
        --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" '${placeholder "out"}/${qtbase.qtQmlPrefix}'
    ''
    # Need QtQuick.Window in QML2_IMPORT_PATH
    + ''
      substituteInPlace tests/CMakeLists.txt \
        --replace-fail 'QML2_IMPORT_PATH=' 'QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}:'
    '';

  preBuild =
    # For qmlplugindump
    ''
      export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT6" withQt6)
    (lib.cmakeBool "ENABLE_WERROR" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall =
    # *Something* is going wrong when the module path doesn't include the version
    # https://gitlab.com/ubports/development/core/gsettings-qt/-/merge_requests/7#note_2952471601
    ''
      mv -v $out/${qtbase.qtQmlPrefix}/GSettings $out/${qtbase.qtQmlPrefix}/GSettings.1.0
    '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Library to access GSettings from Qt";
    homepage = "https://gitlab.com/ubports/core/gsettings-qt";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      ("gsettings-qt" + lib.optionalString withQt6 "6")
    ];
  };
})
