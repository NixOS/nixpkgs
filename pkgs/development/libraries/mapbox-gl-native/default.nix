{ lib, mkDerivation, fetchFromGitHub, fetchpatch, cmake, pkg-config
, qtbase, curl, libuv, glfw3, rapidjson }:

mkDerivation rec {
  pname = "mapbox-gl-native";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "mapbox-gl-native";
    rev = "maps-v${version}";
    sha256 = "027rw23yvd5a6nl9b5hsanddc44nyb17l2whdcq9fxb9n6vcda4c";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/mapbox/mapbox-gl-native/pull/16591
    (fetchpatch {
      name = "add-support-for-qmapboxgl-installation.patch";
      url = "https://github.com/mapbox/mapbox-gl-native/commit/e18467d755f470b26f61f6893eddd76ecf0816e6.patch";
      sha256 = "0gs7wmkvyhf2db4cwbsq31sprsh1avi70ggvi32bk0wn3cw4d79b";
    })
    (fetchpatch {
      name = "add-support-for-using-qmapboxgl-as-a-proper-cmake-dependency.patch";
      url = "https://github.com/mapbox/mapbox-gl-native/commit/ab27b9b8207754ef731b588d187c470ffb084455.patch";
      sha256 = "1lr5p1g4qaizs57vjqry9aq8k1ki59ks0y975chlnrm2sffp140r";
    })
    (fetchpatch {
      name = "skip-license-check.patch";
      url = "https://git.alpinelinux.org/aports/plain/testing/mapbox-gl-native/0002-skip-license-check.patch?id=6751a93dca26b0b3ceec9eb151272253a2fe497e";
      sha256 = "1yybwzxbvn0lqb1br1fyg7763p2h117s6mkmywkl4l7qg9daa7ba";
    })
    (fetchpatch {
      name = "fix-compilation.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-compilation.patch?h=mapbox-gl-native";
      hash = "sha256-KgJHyoIdKdnQo+gedns3C+mEXlaTH/UtyQsaYR1T3iI=";
    })
  ];

  postPatch = ''
    # don't use vendored rapidjson
    rm -r vendor/mapbox-base/extras/rapidjson
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ curl libuv glfw3 qtbase rapidjson ];

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
    maintainers = with maintainers; [ Thra11 dotlambda ];
    platforms = platforms.linux;
  };
}
