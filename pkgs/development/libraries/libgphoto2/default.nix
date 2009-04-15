{stdenv, fetchurl, pkgconfig, libusb, libtool, libexif, libjpeg, gettext}:

stdenv.mkDerivation rec {
  name = "libgphoto2-2.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "1pipdwjxbjg7y9n5ldz6qlpiiiqyba6jx315277ams5d8jxg2bfk";
  };
  
  buildInputs = [pkgconfig libusb libtool libexif libjpeg gettext];

  meta = {
    homepage = http://www.gphoto.org/proj/libgphoto2/;
    description = "A library for accessing digital cameras";
    license = "LGPL-2";
  };
}
