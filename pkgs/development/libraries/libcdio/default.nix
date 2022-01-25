{ lib, stdenv, fetchurl, fetchpatch, libcddb, pkg-config, ncurses, help2man, libiconv, Carbon, IOKit }:

stdenv.mkDerivation rec {
  pname = "libcdio";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://gnu/libcdio/libcdio-${version}.tar.bz2";
    sha256 = "0avi6apv5ydjy6b9c3z9a46rvp5i57qyr09vr7x4nndxkmcfjl45";
  };

  patches = [
    # pull pending upstream patch to fix build on ncurses-6.3:
    #  https://savannah.gnu.org/patch/index.php?10130
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://savannah.gnu.org/patch/download.php?file_id=52179";
      sha256 = "1v15gxhpi4bgcr12pb3d9c3hiwj0drvc832vic7sham34lhjmcbb";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkg-config help2man ];
  buildInputs = [ libcddb ncurses ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Carbon IOKit ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-independent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    homepage = "https://www.gnu.org/software/libcdio/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
