{ stdenv, fetchFromGitHub, icestorm }:

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2017.11.05";

  src = fetchFromGitHub {
    owner  = "cseed";
    repo   = "arachne-pnr";
    rev    = "1e81432830c75c505c76e419619f605a6c4c7583";
    sha256 = "0lzblmi1klbsmd32h8nh027npm1z1a199lng13lcrqwr17lhb7my";
  };

  enableParallelBuilding = true;
  makeFlags =
    [ "PREFIX=$(out)" "ICEBOX=${icestorm}/share/icebox"
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
