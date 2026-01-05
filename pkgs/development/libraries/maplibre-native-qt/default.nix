{
  cmake,
  fetchFromGitHub,
  lib,
  qtlocation,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maplibre-native-qt";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "maplibre-native-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h7PFoGJ5P+k5AEv+y0XReYnPdP/bD4nr/uW9jZ5DCy4=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionals (lib.versionAtLeast qtlocation.version "6.10") ''
    # fix build with Qt 6.10
    # included in https://github.com/maplibre/maplibre-native-qt/pull/216
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_package(Qt''${QT_VERSION_MAJOR} COMPONENTS Location REQUIRED)' \
                     'find_package(Qt''${QT_VERSION_MAJOR} COMPONENTS Location LocationPrivate REQUIRED)'
  '';

  nativeBuildInputs = [
    cmake
  ];

  env.CXXFLAGS = toString [
    "-DQT_NO_USE_NODISCARD_FILE_OPEN"
  ];

  buildInputs = [
    qtlocation
  ];

  dontWrapQtApps = true; # library only

  meta = {
    changelog = "https://github.com/maplibre/maplibre-native-qt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "MapLibre Native Qt Bindings and Qt Location Plugin";
    homepage = "https://github.com/maplibre/maplibre-native-qt";
    license = with lib.licenses; [
      bsd2
      gpl3
      lgpl3
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.all;
  };
})
