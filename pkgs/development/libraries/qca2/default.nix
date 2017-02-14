{ stdenv, fetchurl, openssl_1_0_2, cmake, pkgconfig, qt, darwin }:

stdenv.mkDerivation rec {
  name = "qca-${version}";
  version = "2.1.3";

  src = fetchurl {
    url = "http://download.kde.org/stable/qca/${version}/src/qca-${version}.tar.xz";
    sha256 = "0lz3n652z208daxypdcxiybl0a9fnn6ida0q7fh5f42269mdhgq0";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl_1_0_2 qt ]
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
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.sander ];
    platforms = platforms.unix;
  };
}
