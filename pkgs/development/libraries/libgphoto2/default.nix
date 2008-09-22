{stdenv, fetchurl, pkgconfig, libusb, libtool, libexif, libjpeg, gettext}:

stdenv.mkDerivation rec {
  name = "libgphoto2-2.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "09jjfh9c7s02dxkwwr8j3kaqffsyiiz7ncbkmdvav1i14xdna6gk";
  };
  
  buildInputs = [pkgconfig libusb libtool libexif libjpeg gettext];

  meta = {
    license = "LGPL-2";
  };
}
