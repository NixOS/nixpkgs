{stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libusb1}:

stdenv.mkDerivation rec {
  name = "libusb-compat-${version}";
  version = "0.1.7";

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  propagatedBuildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "libusb-compat-0.1";
    rev = "v${version}";
    sha256 = "1nybccgjs14b3phhaycq2jx1gym4nf6sghvnv9qdfmlqxacx0jz5";
  };

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl ./fix-headers.patch;

  meta = with stdenv.lib; {
    homepage = "https://libusb.info/";
    repositories.git = "https://github.com/libusb/libusb-compat-0.1";
    description = "cross-platform user-mode USB device library";
    longDescription = ''
      libusb is a cross-platform user-mode library that provides access to USB devices.
      The current API is of 1.0 version (libusb-1.0 API), this library is a wrapper exposing the legacy API.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
