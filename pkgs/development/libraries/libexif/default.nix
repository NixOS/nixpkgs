{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "libexif-0.6.19";

  src = fetchurl {
    url = "mirror://sourceforge/libexif/${name}.tar.bz2";
    sha256 = "1gfa07bzs2lk0n887f1lvz5b9a7abyc3f5zaf39w4sf23hk9axpr";
  };

  buildInputs = [ gettext ];

  meta = {
    homepage = http://libexif.sourceforge.net/;
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = "LGPL 2.1";
  };

}
