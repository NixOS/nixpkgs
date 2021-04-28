{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, zlib, curl, protobuf, prime-server, boost, sqlite, libspatialite
, luajit, geos, python3, zeromq }:

stdenv.mkDerivation rec {
  pname = "valhalla";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "valhalla";
    repo = "valhalla";
    rev = version;
    sha256 = "04vxvzy6hnhdvb9lh1p5vqzzi2drv0g4l2gnbdp44glipbzgd4dr";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    zlib curl protobuf prime-server boost sqlite libspatialite
    luajit geos python3 zeromq
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DENABLE_BENCHMARKS=OFF"
  ];

  meta = with lib; {
    description = "Open Source Routing Engine for OpenStreetMap";
    homepage = "https://valhalla.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
