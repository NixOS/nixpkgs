{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  qtbase,
  qtlocation,
  maplibre-gl-native,
}:

mkDerivation rec {
  pname = "mapbox-gl-qml";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "mapbox-gl-qml";
    rev = version;
    hash = "sha256-zZcD85nOZZ067FRvSuzE8lr2gyuVxpcZGp44D4ayc3Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    curl
    qtlocation
    maplibre-gl-native
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace ' ''${QT_INSTALL_QML}' " $out/${qtbase.qtQmlPrefix}"
  '';

  meta = with lib; {
    description = "Unofficial Mapbox GL Native bindings for Qt QML";
    homepage = "https://github.com/rinigus/mapbox-gl-qml";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      Thra11
      dotlambda
    ];
    platforms = platforms.linux;
  };
}
