{ stdenv, fetchFromGitHub, icestorm }:

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2018.01.10";

  src = fetchFromGitHub {
    owner  = "cseed";
    repo   = "arachne-pnr";
    rev    = "24f6b9c341910f6aaca1498872fe2e99ff8210cf";
    sha256 = "0jd91hx16jx0p0jiqhgh1kbh59k82i4979f4xp4wzc249br7lxlv";
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
