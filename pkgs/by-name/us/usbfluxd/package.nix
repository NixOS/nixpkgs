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
stdenv.mkDerivation {
  pname = "usbfluxd";
  version = "v1.0";

  src = fetchFromGitHub {
    owner = "corellium";
    repo = "usbfluxd";
    rev = "v1.0";
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

  #configureFlags = [ "--without-static-libplist" ];
  patchPhase = ''
    substituteInPlace configure.ac \
      --replace 'with_static_libplist=yes' 'with_static_libplist=no'
    # Patch utils.h to comment out duplicate enum definitions.
    
    substituteInPlace usbfluxd/utils.h \
      --replace-fail PLIST_FORMAT_BINARY //PLIST_FORMAT_BINARY  \
      --replace-fail PLIST_FORMAT_XML, NOT_PLIST_FORMAT_XML  
  '';

  meta = with lib; {
    homepage = "https://github.com/corellium/usbfluxd";
    description = "Redirects the standard usbmuxd socket to allow connections to local and remote usbmuxd instances so remote devices appear connected locally.";
    license = licenses.gpl2Plus;
    maintainers = [];
  };
}
