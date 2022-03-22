{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, zlib, curl, protobuf, prime-server, boost, sqlite, libspatialite
, luajit, geos39, python3, zeromq }:

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
