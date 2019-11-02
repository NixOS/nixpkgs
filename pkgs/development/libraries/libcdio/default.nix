{ stdenv, fetchurl, libcddb, pkgconfig, ncurses, help2man, libiconv, Carbon, IOKit }:

stdenv.mkDerivation rec {
  name = "libcdio-2.1.0";

  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.bz2";
    sha256 = "0avi6apv5ydjy6b9c3z9a46rvp5i57qyr09vr7x4nndxkmcfjl45";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libcddb ncurses help2man ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Carbon IOKit ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "A library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-independent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    homepage = https://www.gnu.org/software/libcdio/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
