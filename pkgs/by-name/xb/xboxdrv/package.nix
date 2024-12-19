{
  lib,
  stdenv,
  fetchFromGitHub,
  scons,
  libX11,
  pkg-config,
  libusb1,
  boost,
  glib,
  dbus-glib,
}:

stdenv.mkDerivation rec {
  pname = "xboxdrv";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "xboxdrv";
    repo = "xboxdrv";
    rev = "v${version}";
    hash = "sha256-R0Bt4xfzQA1EmZbf7lcWLwSSUayf5Y711QhlAVhiLrY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  nativeBuildInputs = [
    pkg-config
    scons
  ];
  buildInputs = [
    libX11
    libusb1
    boost
    glib
    dbus-glib
  ];
  enableParallelBuilding = true;
  dontUseSconsInstall = true;

  patches = [
    ./fix-60-sec-delay.patch
    ./scons-py3.patch
    ./scons-v4.2.0.patch
    ./xboxdrvctl-py3.patch
  ];

  meta = with lib; {
    homepage = "https://xboxdrv.gitlab.io/";
    description = "Xbox/Xbox360 (and more) gamepad driver for Linux that works in userspace";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
