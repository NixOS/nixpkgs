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
  version = "1.1.1+date=2025-12-06";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "usbmuxd";
    rev = "3ded00c9985a5108cfc7591a309f9a23d57a8cba";
    hash = "sha256-0ZxEdU6LAUT0XfRk/PnRGl+r2ofttpffI8MiQljukVA=";
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
    maintainers = with lib.maintainers; [ ProxyVT ];
    mainProgram = "usbmuxd";
  };
})
