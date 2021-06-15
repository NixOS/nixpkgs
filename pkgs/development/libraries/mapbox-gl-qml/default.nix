{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, curl
, qtbase
, qtlocation
, mapbox-gl-native
}:

mkDerivation rec {
  pname = "mapbox-gl-qml";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "mapbox-gl-qml";
    rev = version;
    sha256 = "sha256-E6Pkr8khzDbhmJxzK943+H6cDREgwAqMnJQ3hQWU7fw=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ curl qtlocation mapbox-gl-native ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace ' ''${QT_INSTALL_QML}' " $out/${qtbase.qtQmlPrefix}"
  '';

  # Package expects qt5 subdirectory of mapbox-gl-native to be in the include path
  NIX_CFLAGS_COMPILE = "-I${mapbox-gl-native}/include/qt5";

  meta = with lib; {
    description = "Unofficial Mapbox GL Native bindings for Qt QML";
    homepage = "https://github.com/rinigus/mapbox-gl-qml";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ Thra11 dotlambda ];
    platforms = platforms.linux;
  };
}
