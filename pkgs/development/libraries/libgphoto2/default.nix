{ stdenv, fetchurl, pkgconfig, libusb1, libtool, libexif, libjpeg, gettext, libxml2 }:

stdenv.mkDerivation rec {
  name = "libgphoto2-2.5.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "057dnyrxr0vy2zs4fhscpig42kvlsy9fg4gj20fhvjcvp3pak8xl";
  };

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ libtool libjpeg libxml2 ];

  # These are mentioned in the Requires line of libgphoto's pkg-config file.
  propagatedBuildInputs = [ libusb1 libexif ];

  NIX_CFLAGS_COMPILE = "-I${libxml2}/include/libxml2"; # bogus detection again

  meta = {
    homepage = http://www.gphoto.org/proj/libgphoto2/;
    description = "A library for accessing digital cameras";
    longDescription = ''
      This is the library backend for gphoto2. It contains the code for PTP,
      MTP, and other vendor specific protocols for controlling and transferring data
      from digital cameras.
    '';
    # XXX: the homepage claims LGPL, but several src files are lgpl21Plus
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = with stdenv.lib.platforms; unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
