{ stdenv, fetchFromGitHub, icestorm }:

with builtins;

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2018.05.03";

  src = fetchFromGitHub {
    owner  = "cseed";
    repo   = "arachne-pnr";
    rev    = "ea2d04215bc0fd6072cda244caeb6670892033b3";
    sha256 = "0qhf5djyh0pzmgv33rjnnqq6asmmwxjdadvr18a83iy9pll6gg5k";
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
