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
<<<<<<< HEAD
  version = "22.7.0";
=======
  version = "22.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Jc8qNONdlyzpCCgwhMdwG2D2CO9o0l4vH9sE+NjidE4=";
=======
    hash = "sha256-QHAkPZoLQG+UQ1YNdad+XYOywqLqIW1vBmcFkuf3pXU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Libraries module for the Greenbone Vulnerability Management Solution";
    homepage = "https://github.com/greenbone/gvm-libs";
    changelog = "https://github.com/greenbone/gvm-libs/releases/tag/v${version}";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
