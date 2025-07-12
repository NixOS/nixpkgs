{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ace,
  ycm-cmake-modules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yarp";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "robotology";
    repo = "yarp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nZHLbP3t3BjuhwGHjh9n0Rzf9teqvoACkbDzwtmG0ww=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    ace
    ycm-cmake-modules
  ];

  cmakeFlags = [
    (lib.cmakeOptionType "bool" "YARP_COMPILE_UNMAINTAINED" "ON")
    (lib.cmakeOptionType "bool" "CREATE_YARPC" "ON")
    (lib.cmakeOptionType "bool" "CREATE_YARPCXX" "ON")
    # error: format not a string literal and no format arguments
    # yarp::os::Log(__FILE__, __LINE__, __YFUNCTION__, "", nullptr, (component)()).info(__VA_ARGS__)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=format-security")
  ];

  meta = {
    description = "Yet Another Robot Platform";
    homepage = "http://yarp.it";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
})
