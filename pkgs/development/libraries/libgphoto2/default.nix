{stdenv, fetchurl, pkgconfig, libusb, libtool, libexif, libjpeg, gettext}:

stdenv.mkDerivation rec {
  name = "libgphoto2-${meta.version}";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "1h0bwrbc69yq561pw4fjyclwvk0g6rrj3pw6zrdx33isipi15d2z";
  };
  
  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ libtool libjpeg ];

  # These are mentioned in the Requires line of libgphoto's pkg-config file.
  propagatedBuildInputs = [ libusb libexif ];

  meta = {
    homepage = http://www.gphoto.org/proj/libgphoto2/;
    description = "A library for accessing digital cameras";
    longDescription = ''
      This is the library backend for gphoto2. It contains the code for PTP,
      MTP, and other vendor specific protocols for controlling and transferring data
      from digital cameras. 
    '';
    version = "2.5.4";
    # XXX: the homepage claims LGPL, but several src files are lgpl21Plus
    license = stdenv.lib.licenses.lgpl21Plus; 
    platforms = with stdenv.lib.platforms; unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
