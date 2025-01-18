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

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qtlocation
  ];

  dontWrapQtApps = true; # library only

  meta = with lib; {
    changelog = "https://github.com/maplibre/maplibre-native-qt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "MapLibre Native Qt Bindings and Qt Location Plugin";
    homepage = "https://github.com/maplibre/maplibre-native-qt";
    license = with licenses; [
      bsd2
      gpl3
      lgpl3
    ];
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.all;
  };
})
