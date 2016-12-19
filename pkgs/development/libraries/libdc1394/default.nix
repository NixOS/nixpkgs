{ stdenv, fetchurl, libraw1394, libusb1
, CoreServices
}:

stdenv.mkDerivation rec {
  name = "libdc1394-2.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/libdc1394/${name}.tar.gz";
    sha256 = "1p9b4ciy97s04gmp7656cybr1zfd79hlw0ffhfb52m3zcn07h6aa";
  };

  buildInputs = [ libusb1 ]
    ++ stdenv.lib.optional stdenv.isLinux libraw1394
    ++ stdenv.lib.optional stdenv.isDarwin CoreServices;

  meta = {
    homepage = http://sourceforge.net/projects/libdc1394/;
    description = "Capture and control API for IIDC compliant cameras";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.unix;
  };
}
