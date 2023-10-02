{ lib
, stdenv
, cmake
, doxygen
, fetchFromGitHub
, glib
, glib-networking
, gnutls
, gpgme
, hiredis
, libgcrypt
, libnet
, libpcap
, libssh
, libuuid
, libxcrypt
, libxml2
, paho-mqtt-c
, pkg-config
, zlib
, freeradius
}:

stdenv.mkDerivation rec {
  pname = "gvm-libs";
  version = "22.7.1";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TSi537RLZGwnyC1nL/Ge3lTlV2FmH1nmAzFSHmaTv04=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    glib
    glib-networking
    gnutls
    gpgme
    hiredis
    libgcrypt
    freeradius
    libnet
    libpcap
    libssh
    libuuid
    libxcrypt
    libxml2
    paho-mqtt-c
    zlib
  ];

  cmakeFlags = [
    "-DGVM_RUN_DIR=${placeholder "out"}/run/gvm"
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "Libraries module for the Greenbone Vulnerability Management Solution";
    homepage = "https://github.com/greenbone/gvm-libs";
    changelog = "https://github.com/greenbone/gvm-libs/releases/tag/v${version}";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
