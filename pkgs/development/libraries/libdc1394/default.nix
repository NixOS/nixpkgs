{ stdenv, fetchurl, libraw1394, libusb1 }:

stdenv.mkDerivation rec {
  name = "libdc1394-2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/libdc1394/${name}.tar.gz";
    sha256 = "0v7y8r8zxpkcw8fhwr6x08wkbpfzs5snw5s589fpqmn569f1grn6";
  };

  buildInputs = [ libraw1394 libusb1 ];

  meta = {
    homepage = http://sourceforge.net/projects/libdc1394/;
    description = "Capture and control API for IIDC compliant cameras";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
