{stdenv, fetchurl, pkgconfig, libusb, libtool, libexif, libjpeg, gettext}:

stdenv.mkDerivation rec {
  name = "libgphoto2-2.4.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "12m99hcak59ppq1ijnfsrcm09mdj102f1xjmz4myggwjdymwc3lq";
  };
  
  buildInputs = [pkgconfig libtool libjpeg gettext];

  # These are mentioned in the Requires line of libgphoto's pkg-config file.
  propagatedBuildInputs = [libusb libexif];

  meta = {
    homepage = http://www.gphoto.org/proj/libgphoto2/;
    description = "A library for accessing digital cameras";
    license = "LGPL 2.1";
  };
}
