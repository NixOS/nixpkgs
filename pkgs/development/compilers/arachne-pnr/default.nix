{ stdenv, fetchFromGitHub, icestorm }:

with builtins;

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2018.02.14";

  src = fetchFromGitHub {
    owner  = "cseed";
    repo   = "arachne-pnr";
    rev    = "b54675413f9aac1d9a1fb0a8e9354bec2a2a8f3c";
    sha256 = "06slsb239qk1r2g96n1g37yp8314cy7yi4g1yf86fr87fr11ml8l";
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
