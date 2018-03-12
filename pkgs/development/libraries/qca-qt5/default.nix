{ stdenv, fetchurl, cmake, openssl, pkgconfig, qtbase }:

stdenv.mkDerivation rec {
  name = "qca-qt5-2.1.3";

  src = fetchurl {
    url = "http://download.kde.org/stable/qca/2.1.3/src/qca-2.1.3.tar.xz";
    sha256 = "0lz3n652z208daxypdcxiybl0a9fnn6ida0q7fh5f42269mdhgq0";
  };

  buildInputs = [ openssl qtbase ];
  nativeBuildInputs = [ cmake pkgconfig ];

  # tells CMake to use this CA bundle file if it is accessible
  preConfigure = ''export QC_CERTSTORE_PATH=/etc/ssl/certs/ca-certificates.crt'';

  # tricks CMake into using this CA bundle file if it is not accessible (in a sandbox)
  cmakeFlags = [ "-Dqca_CERTSTORE=/etc/ssl/certs/ca-certificates.crt" ];

  meta = with stdenv.lib; {
    description = "Qt 5 Cryptographic Architecture";
    homepage = http://delta.affinix.com/qca;
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.lgpl21Plus;
    platforms = with platforms; linux;
  };
}
