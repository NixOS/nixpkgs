{ lib, stdenv, fetchurl, autoconf, bison, boost, flex, texinfo, zlib, gputils ? null
, excludePorts ? [] }:

with lib;

let
  # choices: mcs51 z80 z180 r2k r3ka gbz80 tlcs90 ds390 ds400 pic14 pic16 hc08 s08 stm8
  excludedPorts = excludePorts ++ (optionals (gputils == null) [ "pic14" "pic16" ]);
in

stdenv.mkDerivation rec {
  pname = "sdcc";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${version}.tar.bz2";
    sha256 = "0gskzli17ghnn5qllvn4d56qf9bvvclqjh63nnj63p52smvggvc1";
  };

  buildInputs = [ boost gputils texinfo zlib ];

  nativeBuildInputs = [ autoconf bison flex ];

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
    homepage = "http://sdcc.sourceforge.net/";
    license = with licenses; if (gputils == null) then gpl2Plus else unfreeRedistributable;
    maintainers = with maintainers; [ bjornfor yorickvp ];
    platforms = platforms.all;
  };
}
