{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, qtbase
, curl
, libuv
, glfw3
, rapidjson
}:

mkDerivation rec {
  pname = "maplibre-gl-native";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "maplibre-gl-native";
    rev = "qt-v${version}";
    fetchSubmodules = true;
    hash = "sha256-g5J873U/6mrl27iquPl3BdEGhMxkOdfP15dHr27wa48=";
  };

  patches = [
    (fetchpatch {
      name = "skip-license-check.patch";
      url = "https://git.alpinelinux.org/aports/plain/testing/mapbox-gl-native/0002-skip-license-check.patch?id=6751a93dca26b0b3ceec9eb151272253a2fe497e";
      sha256 = "1yybwzxbvn0lqb1br1fyg7763p2h117s6mkmywkl4l7qg9daa7ba";
    })
  ];

  postPatch = ''
    # don't use vendored rapidjson
    rm -r vendor/mapbox-base/extras/rapidjson
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    libuv
    glfw3
    qtbase
    rapidjson
  ];

  cmakeFlags = [
    "-DMBGL_WITH_QT=ON"
    "-DMBGL_WITH_QT_LIB_ONLY=ON"
    "-DMBGL_WITH_QT_HEADLESS=OFF"
  ];

  meta = with lib; {
    description = "Open-source alternative to Mapbox GL Native";
    homepage = "https://maplibre.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
