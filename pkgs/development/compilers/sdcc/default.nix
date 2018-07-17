{ stdenv, fetchurl, bison, flex, boost, texinfo, autoconf, gputils ? null, disabled ? [] }:
let
  allDisabled = (if gputils == null then [ "pic14" "pic16" ] else []) ++ disabled;
  # choices: mcs51 z80 z180 r2k r3ka gbz80 tlcs90 ds390 ds400 pic14 pic16 hc08 s08 stm8
  inherit (stdenv) lib;
in
stdenv.mkDerivation rec {
  version = "3.7.0";
  name = "sdcc-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${version}.tar.bz2";
    sha256 = "13llvx0j3v5qa7qd4fh7nix4j3alpd3ccprxvx163c4q8q4lfkc5";
  };

  buildInputs = [ bison flex boost texinfo gputils autoconf ];

  configureFlags = ''
    ${lib.concatMapStringsSep " " (f: "--disable-${f}-port") allDisabled}
  '';

  meta = with lib; {
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
    maintainers = [ maintainers.bjornfor maintainers.yorickvp ];
  };
}
