{ stdenv, fetchurl, fetchpatch, gettext }:

stdenv.mkDerivation rec {
  name = "libexif-0.6.21";

  src = fetchurl {
    url = "mirror://sourceforge/libexif/${name}.tar.bz2";
    sha256 = "06nlsibr3ylfwp28w8f5466l6drgrnydgxrm4jmxzrmk5svaxk8n";
  };

  patches = [
   (fetchpatch {
     name = "CVE-2017-7544.patch";
     url = https://sourceforge.net/p/libexif/bugs/_discuss/thread/fc394c4b/489a/attachment/xx.pat;
     sha256 = "1qgk8hgnxr8d63jsc4vljxz9yg33mbml280dq4a6050rmk9wq4la";
   })
  ];
  patchFlags = "-p0";

  buildInputs = [ gettext ];

  meta = {
    homepage = http://libexif.sourceforge.net/;
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
  };

}
