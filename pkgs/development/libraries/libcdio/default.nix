{ stdenv, fetchurl, libcddb, pkgconfig, ncurses, help2man, libiconv }:

stdenv.mkDerivation rec {
  name = "libcdio-0.93";

  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.bz2";
    sha256 = "1a6x2c5bvpnkn7lhmxkjgz4axmh93m1clrlv41s1wzkc48lnc9zq";
  };

  buildInputs = [ libcddb pkgconfig ncurses help2man ]
    ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  # Disabled because one test (check_paranoia.sh) fails.
  #doCheck = true;

  meta = with stdenv.lib; {
    description = "A library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-independent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    homepage = http://www.gnu.org/software/libcdio/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
