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
  version = "1.7.7.1";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "mapbox-gl-qml";
    rev = version;
    hash = "sha256-lmL9nawMY8rNNBV4zNF4N1gn9XZzIZ9Cw2ZRs9bjBaI=";
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
