{stdenv, fetchurl, pkgconfig, libusb, libtool, libexif, libjpeg, gettext}:

stdenv.mkDerivation rec {
  name = "libgphoto2-2.4.11";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "08y40mqy714cg0160lny13z9kyxm63m3ksg8hljy5pspxanbn5ji";
  };
  
  buildNativeInputs = [ pkgconfig gettext ];
  buildInputs = [ libtool libjpeg ];

  # These are mentioned in the Requires line of libgphoto's pkg-config file.
  propagatedBuildInputs = [ libusb libexif ];

  meta = {
    homepage = http://www.gphoto.org/proj/libgphoto2/;
    description = "A library for accessing digital cameras";
    license = "LGPL 2.1";
  };
}
