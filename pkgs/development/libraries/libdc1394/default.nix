{ stdenv, fetchurl, libraw1394, libusb1 }:

stdenv.mkDerivation rec {
  name = "libdc1394-2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/libdc1394/${name}.tar.gz";
    sha256 = "1wkcx4ff094qba1fwllmlr81i7xg7l8dzq7y7pvy3wlbpwd3634j";
  };

  buildInputs = [ libraw1394 libusb1 ];

  meta = {
    homepage = http://sourceforge.net/projects/libdc1394/;
    description = "Capture and control API for IIDC compliant cameras";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
