{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libimobiledevice,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usbmuxd";
  version = "1.1.1+date=2025-09-15";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "usbmuxd";
    rev = "2efa75a0a9ca73f2a5b6ec71e5ae6cb43cdab580";
    hash = "sha256-8Dx8yN/vatD1lp3mzUUSKyx2/plv3geJhz3oQRhl7UM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libimobiledevice
    libusb1
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/libimobiledevice/usbmuxd";
    description = "Socket daemon to multiplex connections from and to iOS devices";
    longDescription = ''
      usbmuxd stands for "USB multiplexing daemon". This daemon is in charge of
      multiplexing connections over USB to an iOS device. To users, it means
      you can sync your music, contacts, photos, etc. over USB. To developers, it
      means you can connect to any listening localhost socket on the device. usbmuxd
      is not used for tethering data transfer which uses a dedicated USB interface as
      a virtual network device. Multiple connections to different TCP ports can happen
      in parallel. The higher-level layers are handled by libimobiledevice.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "usbmuxd";
  };
})
