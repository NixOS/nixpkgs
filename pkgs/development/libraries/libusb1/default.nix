{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libusb-1.0.16";

  src = fetchurl {
    url = "mirror://sourceforge/libusbx/libusbx-1.0.16.tar.bz2";
    sha256 = "105m9jvjr3vrriyg0mwmyf7qla4l71iwwnymrsk3sy9dazwmqcsv";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = stdenv.lib.optional (stdenv.isLinux) udev;

  NIX_LDFLAGS = "-lgcc_s";

  meta = {
    homepage = http://www.libusb.org;
    description = "User-space USB library";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
