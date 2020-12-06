{ stdenv, fetchurl, openssl, cmake, pkgconfig, qt, darwin }:

stdenv.mkDerivation rec {
  pname = "qca";
  version = "2.2.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/qca/${version}/qca-${version}.tar.xz";
    sha256 = "00kv1vsrc8fp556hm8s6yw3240vx3l4067q6vfxrb3gdwgcd45np";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl qt ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  enableParallelBuilding = true;

  # tells CMake to use this CA bundle file if it is accessible
  preConfigure = ''
    export QC_CERTSTORE_PATH=/etc/ssl/certs/ca-certificates.crt
  '';

  # tricks CMake into using this CA bundle file if it is not accessible (in a sandbox)
  cmakeFlags = [ "-Dqca_CERTSTORE=/etc/ssl/certs/ca-certificates.crt" ];

  postPatch = ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture";
    license = "LGPL";
    homepage = "http://delta.affinix.com/qca";
    maintainers = [ maintainers.sander ];
    platforms = platforms.unix;
  };
}
