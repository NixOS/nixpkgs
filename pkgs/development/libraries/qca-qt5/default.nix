{ lib, stdenv, fetchurl, cmake, openssl, pkg-config, qtbase }:

stdenv.mkDerivation rec {
  pname = "qca-qt5";
  version = "2.3.4";

  src = fetchurl {
    url = "http://download.kde.org/stable/qca/${version}/qca-${version}.tar.xz";
    sha256 = "sha256-a2lYgafj/ZX3Oq7m6uq5b2rRflFenCs9SzJy14Yv9cQ=";
  };

  buildInputs = [ openssl qtbase ];
  nativeBuildInputs = [ cmake pkg-config ];

  dontWrapQtApps = true;

  # tells CMake to use this CA bundle file if it is accessible
  preConfigure = "export QC_CERTSTORE_PATH=/etc/ssl/certs/ca-certificates.crt";

  # tricks CMake into using this CA bundle file if it is not accessible (in a sandbox)
  cmakeFlags = [ "-Dqca_CERTSTORE=/etc/ssl/certs/ca-certificates.crt" ];

  meta = with lib; {
    description = "Qt 5 Cryptographic Architecture";
    homepage = "http://delta.affinix.com/qca";
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
  };
}
