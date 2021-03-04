{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtlocation, mapbox-gl-native }:

mkDerivation rec {
  pname = "mapbox-gl-qml";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "mapbox-gl-qml";
    rev = version;
    sha256 = "1izwkfqn8jl83vihcxl2b159sqmkn1amxf92zw0h6psls2g9xhwx";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtlocation mapbox-gl-native ];

  postPatch = ''
    substituteInPlace mapbox-gl-qml.pro \
      --replace '$$[QT_INSTALL_QML]' $out'/${qtbase.qtQmlPrefix}'
  '';

  # Package expects qt5 subdirectory of mapbox-gl-native to be in the include path
  NIX_CFLAGS_COMPILE = "-I${mapbox-gl-native}/include/qt5";

  meta = with lib; {
    description = "Unofficial Mapbox GL Native bindings for Qt QML";
    homepage = "https://github.com/rinigus/mapbox-gl-qml";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
