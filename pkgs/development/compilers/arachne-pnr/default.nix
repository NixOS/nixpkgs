{ stdenv, fetchFromGitHub, icestorm }:

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2017.06.29";

  src = fetchFromGitHub {
    owner = "cseed";
    repo = "arachne-pnr";
    rev = "7e135edb31feacde85ec5b7e5c03fc9157080977";
    sha256 = "1wszcx6hgw4q4r778zswrlwdwvwxq834bkajck8w9yfqwxs9lmq8";
  };

  makeFlags =
    [ "DESTDIR=$(out)" "ICEBOX=${icestorm}/share/icebox"
    ];

  meta = {
    description = "Place and route tool for FPGAs";
    longDescription = ''
      Arachne-pnr implements the place and route step of
      the hardware compilation process for FPGAs. It
      accepts as input a technology-mapped netlist in BLIF
      format, as output by the Yosys [0] synthesis suite
      for example. It currently targets the Lattice
      Semiconductor iCE40 family of FPGAs [1]. Its output
      is a textual bitstream representation for assembly by
      the IceStorm [2] icepack command.
    '';
    homepage = https://github.com/cseed/arachne-pnr;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice ];
    platforms = stdenv.lib.platforms.linux;
  };
}
