{stdenv, fetchurl, pkgconfig, libusb1}:

stdenv.mkDerivation {
  name = "libusb-compat-0.1.5";

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libusb1 ];

  src = fetchurl {
    url = mirror://sourceforge/libusb/libusb-compat-0.1.5.tar.bz2;
    sha256 = "0nn5icrfm9lkhzw1xjvaks9bq3w6mjg86ggv3fn7kgi4nfvg8kj0";
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
