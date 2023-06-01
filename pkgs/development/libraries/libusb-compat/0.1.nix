{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "libusb-compat";
  version = "0.1.8";

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "libusb-compat-0.1";
    rev = "v${version}";
    sha256 = "sha256-pAPERYSxoc47gwpPUoMkrbK8TOXyx03939vlFN0hHRg=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./fix-headers.patch;

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libusb1 ];

  # without this, libusb-compat is unable to find libusb1
  postFixup = ''
    find $out/lib -name \*.so\* -type f -exec \
      patchelf --set-rpath ${lib.makeLibraryPath buildInputs} {} \;
  '';

  meta = with lib; {
    homepage = "https://libusb.info/";
    description = "cross-platform user-mode USB device library";
    longDescription = ''
      libusb is a cross-platform user-mode library that provides access to USB devices.
      The current API is of 1.0 version (libusb-1.0 API), this library is a wrapper exposing the legacy API.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
