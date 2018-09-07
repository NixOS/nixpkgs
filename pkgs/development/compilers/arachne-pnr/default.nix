{ stdenv, fetchFromGitHub, icestorm }:

with builtins;

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2018.05.13";

  src = fetchFromGitHub {
    owner  = "cseed";
    repo   = "arachne-pnr";
    rev    = "5d830dd94ad956d17d77168fe7718f22f8b55b33";
    sha256 = "1i056m5zn21nml65q9x9mgks4ydl8lqya6a4szix01vn3k0g06vn";
  };

  enableParallelBuilding = true;
  makeFlags =
    [ "PREFIX=$(out)"
      "ICEBOX=${icestorm}/share/icebox"
    ];

  patchPhase = ''
    substituteInPlace ./Makefile \
      --replace 'echo UNKNOWN' 'echo ${substring 0 10 src.rev}'
  '';

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
