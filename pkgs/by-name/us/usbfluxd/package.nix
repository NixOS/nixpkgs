{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libimobiledevice,
  libusb1,
  libusbmuxd,
  usbmuxd,
  libplist,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "usbfluxd";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "corellium";
    repo = "usbfluxd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tfAy3e2UssPlRB/8uReLS5f8N/xUUzbjs8sKNlr40T0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libimobiledevice
    libusb1
    libusbmuxd
    usbmuxd
    libplist
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'with_static_libplist=yes' 'with_static_libplist=no'
    substituteInPlace usbfluxd/utils.h \
      --replace-fail PLIST_FORMAT_BINARY //PLIST_FORMAT_BINARY \
      --replace-fail PLIST_FORMAT_XML, NOT_PLIST_FORMAT_XML
  '';

  meta = {
    homepage = "https://github.com/corellium/usbfluxd";
    description = "Redirects the standard usbmuxd socket to allow connections to local and remote usbmuxd instances so remote devices appear connected locally";
    license = lib.licenses.gpl2Plus;
    mainProgram = "usbfluxctl";
    maintainers = with lib.maintainers; [ x807x ];
  };
})
