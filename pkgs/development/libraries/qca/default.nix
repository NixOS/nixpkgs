{
  lib,
  stdenv,
  fetchurl,
  cmake,
  openssl,
  pkg-config,
  qtbase,
  qt5compat ? null,
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
in
stdenv.mkDerivation rec {
  pname = "qca";
  version = "2.3.8";

  src = fetchurl {
    url = "mirror://kde/stable/qca/${version}/qca-${version}.tar.xz";
    sha256 = "sha256-SHWcqGoCAkYdkIumYTQ4DMO7fSD+08AxufwCiXlqgmQ=";
  };

  buildInputs = [
    openssl
    qtbase
    qt5compat
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  dontWrapQtApps = true;

  # tells CMake to use this CA bundle file if it is accessible
  preConfigure = "export QC_CERTSTORE_PATH=/etc/ssl/certs/ca-certificates.crt";

  cmakeFlags = [
    (lib.cmakeBool "QT6" isQt6)
    # tricks CMake into using this CA bundle file if it is not accessible (in a sandbox)
    "-Dqca_CERTSTORE=/etc/ssl/certs/ca-certificates.crt"
  ];

  meta = with lib; {
    description = "Qt Cryptographic Architecture";
    homepage = "https://invent.kde.org/libraries/qca";
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
  };
}
