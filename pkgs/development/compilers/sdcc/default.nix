{ stdenv, fetchurl, autoconf, bison, boost, flex, texinfo, gputils ? null
, excludePorts ? [] }:

with stdenv.lib;

let
  # choices: mcs51 z80 z180 r2k r3ka gbz80 tlcs90 ds390 ds400 pic14 pic16 hc08 s08 stm8
  excludedPorts = excludePorts ++ (optionals (gputils == null) [ "pic14" "pic16" ]);
in

stdenv.mkDerivation rec {
  name = "sdcc-${version}";
  version = "3.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${version}.tar.bz2";
    sha256 = "13llvx0j3v5qa7qd4fh7nix4j3alpd3ccprxvx163c4q8q4lfkc5";
  };

  buildInputs = [ autoconf bison boost flex gputils texinfo ];

  configureFlags = map (f: "--disable-${f}-port") excludedPorts;

  meta = {
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
    license = with licenses; if (gputils == null) then gpl2 else unfreeRedistributable;
    maintainers = with maintainers; [ bjornfor yorickvp ];
    platforms = platforms.linux;
  };
}
