{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  makeFontsConf,
  testers,
  cmake,
  cmake-extras,
  dbus,
  doxygen,
  glib,
  graphviz,
  gtest,
  libqtdbustest,
  pkg-config,
  python3,
  qtbase,
  writableTmpDirAsHomeHook,
  withDocumentation ? true,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-api";
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-api";
    tag = finalAttrs.version;
    hash = "sha256-V26qaVGfG+kRLjR9CnUzSQr0pbo8kz4pyZ0TvEwybgE=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  postPatch = ''
    patchShebangs $(find test -name '*.py')
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withDocumentation [
    doxygen
    graphviz
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    cmake-extras
    glib
  ];

  nativeCheckInputs = [
    dbus
    python3
  ];

  checkInputs = [
    gtest
    libqtdbustest
    qtbase
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "NO_TESTS" (!finalAttrs.finalPackage.doCheck))
  ];

  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  doCheck =
    stdenv.buildPlatform.canExecute stdenv.hostPlatform
    # Only tests use Qt, Qt5 support dropped in 0.4.0
    && withQt6;

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Lomiri API Library for integrating with the Lomiri shell";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-api";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-api/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "liblomiri-api"
    ];
  };
})
