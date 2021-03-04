{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config
, qtbase, curl, libuv, glfw3 }:

mkDerivation rec {
  pname = "mapbox-gl-native";
  version = "2020.06.07";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "mapbox-gl-native";
    rev = "e18467d755f470b26f61f6893eddd76ecf0816e6";
    sha256 = "1x271gg9h81jpi70pv63i6lsa1zg6bzja9mbz7bsa4s02fpqy7wh";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ curl libuv glfw3 qtbase ];

  cmakeFlags = [
    "-DMBGL_WITH_QT=ON"
    "-DMBGL_WITH_QT_LIB_ONLY=ON"
    "-DMBGL_WITH_QT_HEADLESS=OFF"
  ];
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations -Wno-error=type-limits";

  meta = with lib; {
    description = "Interactive, thoroughly customizable maps in native Android, iOS, macOS, Node.js, and Qt applications, powered by vector tiles and OpenGL";
    homepage = "https://mapbox.com/mobile";
    license = licenses.bsd2;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
