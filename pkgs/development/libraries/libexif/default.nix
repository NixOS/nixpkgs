{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "libexif-0.6.21";

  src = fetchurl {
    url = "mirror://sourceforge/libexif/${name}.tar.bz2";
    sha256 = "06nlsibr3ylfwp28w8f5466l6drgrnydgxrm4jmxzrmk5svaxk8n";
  };

  buildInputs = [ gettext ];

  meta = {
    homepage = http://libexif.sourceforge.net/;
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = stdenv.lib.licenses.lgpl21;
  };

}
