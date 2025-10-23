{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  udev,
  libcec_platform,
  withLibraspberrypi ? false,
  libraspberrypi,
}:

stdenv.mkDerivation rec {
  pname = "libcec";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "libcec";
    rev = "libcec-${version}";
    sha256 = "sha256-t8GUQKWTcxjyaAlsTP4C+heYiVYowG7x+fmjHPND7As=";
  };

  # Fix dlopen path
  postPatch = ''
    substituteInPlace include/cecloader.h --replace "\"libcec." "\"$out/lib/libcec."
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    libcec_platform
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux udev
  ++ lib.optional withLibraspberrypi libraspberrypi;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DHAVE_LINUX_API=1"
  ];

  meta = with lib; {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = "http://libcec.pulse-eight.com";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    teams = [ teams.kodi ];
  };
}
