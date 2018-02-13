{ stdenv, fetchFromGitHub, icestorm }:

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2018.02.04";

  src = fetchFromGitHub {
    owner  = "cseed";
    repo   = "arachne-pnr";
    rev    = "c21df0062c6ee13e8c8280cefbb7c017823336c0";
    sha256 = "1ah1gn07av3ff5lnay4p7dahaacbyj0mfakbx7g5fs3p1m1m8p1k";
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
