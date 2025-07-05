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
    "-DYARP_COMPILE_UNMAINTAINED:BOOL=ON"
    "-DCREATE_YARPC:BOOL=ON"
    "-DCREATE_YARPCXX:BOOL=ON"
    "-DCMAKE_INSTALL_LIBDIR=${placeholder "out"}/lib"
    # error: format not a string literal and no format arguments
    # yarp::os::Log(__FILE__, __LINE__, __YFUNCTION__, "", nullptr, (component)()).info(__VA_ARGS__)
    "-DCMAKE_CXX_FLAGS=-Wno-error=format-security"
  ];

  postInstall = "mv ./$out/lib/*.so $out/lib/";

  meta = {
    description = "Yet Another Robot Platform";
    homepage = "http://yarp.it";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
})
