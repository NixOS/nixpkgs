{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  cmake,
  qmake,
  qtbase,
  qtdeclarative,

  # Qt5-only
  qtgraphicaleffects ? null,
  qtquickcontrols2 ? null,

  # Qt6-only
  qt5compat ? null,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qqc2-suru-style";
  version = "0.20230630";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/qqc2-suru-style";
    tag = finalAttrs.version;
    hash = "sha256-kAgHsNWwUWxHg26bTMmlq8m9DR4+ob4pl/oUX7516hM=";
  };

  patches = [
    # https://gitlab.com/ubports/development/core/qqc2-suru-style/-/merge_requests/69
    ./1501-treewide-Port-to-Qt6.patch
  ];

  postPatch = ''
    substituteInPlace qqc2-suru/suru.pri \
      --replace-fail '$$[QT_INSTALL_QML]' "$out/${qtbase.qtQmlPrefix}"

    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_MAJOR_VERSION}/qml" \
        '${qtbase.qtQmlPrefix}'
  '';

  # QMake can't find Qt modules from buildInputs
  strictDeps = withQt6;

  nativeBuildInputs = lib.optionals (!withQt6) [ qmake ] ++ lib.optionals withQt6 [ cmake ];

  propagatedBuildInputs = [
    qtdeclarative
  ]
  ++ lib.optionals (!withQt6) [
    # Qt6: Deprecated, moved to core5compat
    qtgraphicaleffects

    # Qt6: Folded into qtdeclarative
    qtquickcontrols2
  ]
  ++ lib.optionals withQt6 [
    # Not ported away from qtgraphicaleffects yet
    qt5compat
  ];

  cmakeFlags = [
    (lib.strings.cmakeFeature "QT_VERSION_MAJOR" (lib.versions.major qtbase.version))
  ];

  # QML plugin
  dontWrapQtApps = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Suru Style for QtQuick Controls 2";
    homepage = "https://gitlab.com/ubports/development/core/qqc2-suru-style";
    changelog = "https://gitlab.com/ubports/development/core/qqc2-suru-style/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl2Plus
      lgpl3Only
      cc-by-sa-30
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.unix;
  };
})
