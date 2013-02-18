{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libusb-1.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/libusb/${name}.tar.bz2";
    sha256 = "16sz34ix6hw2wwl3kqx6rf26fg210iryr68wc439dc065pffw879";
  };

  buildInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.libusb.org;
    description = "User-space USB library";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
