{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "libexif-0.6.20";

  src = fetchurl {
    url = "mirror://sourceforge/libexif/${name}.tar.bz2";
    sha256 = "05fphfmgrni6838v0lkcqv88fbw7r1mdw3ypy3bh567vv05x4wm7";
  };

  buildInputs = [ gettext ];

  meta = {
    homepage = http://libexif.sourceforge.net/;
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = "LGPL 2.1";
  };

}
