{ lib, stdenv, fetchurl, cmake, openssl, pkg-config, qtbase }:

stdenv.mkDerivation rec {
  pname = "qca-qt5";
  version = "2.3.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/qca/${version}/qca-${version}.tar.xz";
    sha256 = "sha256-wThREJq+/EYjNwmJ+uOnRb9rGss8KhOolYU5gj6XTks=";
  };

  patches = [
    # Pull upstream fix for gcc-11
    (fetchurl {
      url = "https://github.com/KDE/qca/commit/32275f1a74c161d2fed8c056b2dd9555687a22f2.patch";
      sha256 = "sha256-SUH2eyzP2vH/ZjYcX8ybwiqhoTm/QjuEpTKjb2iH1No=";
    })
  ];

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
