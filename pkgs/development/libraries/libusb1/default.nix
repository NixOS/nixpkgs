{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libusb-1.0.17";

  src = fetchurl {
    url = "mirror://sourceforge/libusbx/libusbx-1.0.17.tar.bz2";
    sha256 = "1f25a773x9x5n48a0mcigyk77ay0hkiz6y6bi4588wzf7wn8svw7";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = stdenv.lib.optional (stdenv.isLinux) udev;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  meta = {
    homepage = http://www.libusb.org;
    description = "User-space USB library";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
