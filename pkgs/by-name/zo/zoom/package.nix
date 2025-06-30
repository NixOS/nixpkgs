{
  lib,
  stdenv,
  fetchurl,
  perl,
  expat,
  fontconfig,
  freetype,
  xorg,
}:

# !!! assert freetype == xorg.freetype

stdenv.mkDerivation rec {
  pname = "zoom";
  version = "1.1.5";

  src = fetchurl {
    url = "https://www.logicalshift.co.uk/unix/zoom/zoom-${version}.tar.gz";
    hash = "sha256-8pZ/HAVV341K6QRDUC0UzzO2rGW2AvSZ++Pp445V27w=";
  };

  buildInputs = [
    perl
    expat
    fontconfig
    freetype
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXext
    xorg.libXrender
  ];

  env.NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2 -fgnu89-inline";

  meta = with lib; {
    homepage = "https://www.logicalshift.co.uk/unix/zoom/";
    description = "Player for Z-Code, TADS and HUGO stories or games";
    longDescription = ''
      Zoom is a player for Z-Code, TADS and HUGO stories or games. These are
      usually text adventures ('interactive fiction'), and were first created
      by Infocom with the Zork series of games. Throughout the 80's, Infocom
      released many interactive fiction stories before their ambitions to enter
      the database market finally brought them low.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "zoom";
  };
}
