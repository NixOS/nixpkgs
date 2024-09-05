{
  lib,
  stdenv,
  cmake,
  doxygen,
  fetchFromGitHub,
  glib,
  glib-networking,
  gnutls,
  gpgme,
  hiredis,
  libgcrypt,
  libnet,
  libpcap,
  libssh,
  libuuid,
  libxcrypt,
  libxml2,
  openldap,
  paho-mqtt-c,
  pkg-config,
  radcli,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gvm-libs";
  version = "22.10.0";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-libs";
    rev = "refs/tags/v${version}";
    hash = "sha256-o86bNwoGUw6VLESkaamWXPOfrdbFipJZmQCL6W5+nfk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "-Werror" ""
  '';

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
    libnet
    libpcap
    libssh
    libuuid
    libxcrypt
    libxml2
    openldap
    paho-mqtt-c
    radcli
    zlib
  ];

  cmakeFlags = [ "-DGVM_RUN_DIR=${placeholder "out"}/run/gvm" ];

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
