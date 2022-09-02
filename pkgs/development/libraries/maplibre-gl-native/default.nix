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
  version = "unstable-2022-04-07";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "maplibre-gl-native";
    rev = "225f8a4bfe7ad30fd59d693c1fb3ca0ba70d2806";
    fetchSubmodules = true;
    hash = "sha256-NLtpi+bDLTHlnzMZ4YFQyF5B1xt9lzHyZPvEQLlBAnY=";
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
    broken = lib.versionOlder qtbase.version "5.15";
  };
}
