{ lib
, stdenv
, fetchFromGitHub
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

  src = fetchFromGitHub {
    owner = "valhalla";
    repo = "valhalla";
    rev = finalAttrs.version;
    hash = "sha256-1X9vsWsgnzmXn7bCMhN2PNwtfV0RRdzRFZIrQN2PLfA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/bindings/python/CMakeLists.txt \
      --replace "\''${Python_SITEARCH}" "${placeholder "out"}/${python3.sitePackages}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DENABLE_BENCHMARKS=OFF"
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

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libvalhalla.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    changelog = "https://github.com/valhalla/valhalla/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Open Source Routing Engine for OpenStreetMap";
    homepage = "https://valhalla.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
})
