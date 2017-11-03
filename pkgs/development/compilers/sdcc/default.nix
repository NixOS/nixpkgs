{ stdenv, fetchurl, bison, flex, boost, texinfo, gputils ? null }:

stdenv.mkDerivation rec {
  version = "3.6.0";
  name = "sdcc-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${version}.tar.bz2";
    sha256 = "0x53gh5yrrfjvlnkk29mjn8hq4v52alrsf7c8nsyzzq13sqwwpg8";
  };

  # TODO: remove this comment when gputils != null is tested
  buildInputs = [ bison flex boost texinfo gputils ];

  configureFlags = ''
    ${if gputils == null then "--disable-pic14-port --disable-pic16-port" else ""}
  '';

  meta = with stdenv.lib; {
    description = "Small Device C Compiler";
    longDescription = ''
      SDCC is a retargettable, optimizing ANSI - C compiler suite that targets
      the Intel MCS51 based microprocessors (8031, 8032, 8051, 8052, etc.), Maxim
      (formerly Dallas) DS80C390 variants, Freescale (formerly Motorola) HC08 based
      (hc08, s08) and Zilog Z80 based MCUs (z80, z180, gbz80, Rabbit 2000/3000,
      Rabbit 3000A). Work is in progress on supporting the Microchip PIC16 and
      PIC18 targets. It can be retargeted for other microprocessors.
    '';
    homepage = http://sdcc.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
