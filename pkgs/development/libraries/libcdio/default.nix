{ stdenv, fetchurl, libcddb, pkgconfig, ncurses, help2man, libiconv, Carbon, IOKit }:

stdenv.mkDerivation rec {
  name = "libcdio-2.0.0";

  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.bz2";
    sha256 = "0jr8ppdm80c533nzmrpz3iffnpc6nhvsria1di9f4jg1l19a03fd";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libcddb ncurses help2man ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Carbon IOKit ];

  doCheck = true;

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
