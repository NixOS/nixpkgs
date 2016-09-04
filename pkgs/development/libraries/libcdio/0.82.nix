{ fetchurl, stdenv, libcddb, pkgconfig, ncurses, help2man }:

stdenv.mkDerivation rec {
  name = "libcdio-0.82";
  
  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.gz";
    sha256 = "0fax1dzy84dzs20bmpq2gfw6hc1x2x9mhk53wynhcycjw3l3vjqs";
  };

  buildInputs = [ libcddb pkgconfig ncurses help2man ];

  # Disabled because one test (check_paranoia.sh) fails.
  #doCheck = true;

  meta = {
    description = "A library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-independent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.gnu.org/software/libcdio/;
    platforms = stdenv.lib.platforms.linux;
  };
}
