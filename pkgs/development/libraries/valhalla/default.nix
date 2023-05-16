<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, boost
, curl
, geos
, libspatialite
, luajit
, prime-server
, protobuf
, python3
, sqlite
, zeromq
, zlib
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valhalla";
  version = "3.4.0";
=======
{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, zlib, curl, protobuf, prime-server, boost, sqlite, libspatialite
, luajit, geos39, python3, zeromq }:

stdenv.mkDerivation rec {
  pname = "valhalla";
  version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "valhalla";
    repo = "valhalla";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-1X9vsWsgnzmXn7bCMhN2PNwtfV0RRdzRFZIrQN2PLfA=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build
    (fetchpatch {
      url = "https://github.com/valhalla/valhalla/commit/e4845b68e8ef8de9eabb359b23bf34c879e21f2b.patch";
      hash = "sha256-xCufmXHGj1JxaMwm64JT9FPY+o0+x4glfJSYLdvHI8U=";
    })
  ];

  postPatch = ''
    substituteInPlace src/bindings/python/CMakeLists.txt \
      --replace "\''${Python_SITEARCH}" "${placeholder "out"}/${python3.sitePackages}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
=======
    rev = version;
    sha256 = "04vxvzy6hnhdvb9lh1p5vqzzi2drv0g4l2gnbdp44glipbzgd4dr";
    fetchSubmodules = true;
  };

  # https://github.com/valhalla/valhalla/issues/2119
  postPatch = ''
    for f in valhalla/mjolnir/transitpbf.h \
             src/mjolnir/valhalla_query_transit.cc; do
      substituteInPlace $f --replace 'SetTotalBytesLimit(limit, limit)' \
                                     'SetTotalBytesLimit(limit)'
    done
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    zlib curl protobuf prime-server boost sqlite libspatialite
    luajit geos39 python3 zeromq
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DENABLE_BENCHMARKS=OFF"
  ];

<<<<<<< HEAD
  env.NIX_CFLAGS_COMPILE = toString [
    # Needed for date submodule with GCC 12 https://github.com/HowardHinnant/date/issues/750
    "-Wno-error=stringop-overflow"
  ];

  buildInputs = [
    boost
    curl
    geos
    libspatialite
    luajit
    prime-server
    protobuf
    python3
    sqlite
    zeromq
    zlib
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libvalhalla.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';

<<<<<<< HEAD
  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    changelog = "https://github.com/valhalla/valhalla/blob/${finalAttrs.src.rev}/CHANGELOG.md";
=======
  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Open Source Routing Engine for OpenStreetMap";
    homepage = "https://valhalla.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
