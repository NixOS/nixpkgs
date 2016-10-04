{ stdenv, fetchFromGitHub, icestorm }:

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2016.08.18";

  src = fetchFromGitHub {
    owner = "cseed";
    repo = "arachne-pnr";
    rev = "52e69ed207342710080d85c7c639480e74a021d7";
    sha256 = "15bdw5yxj76lxrwksp6liwmr6l1x77isf4bs50ys9rsnmiwh8c3w";
  };

  preBuild = ''
    makeFlags="DESTDIR=$out $makeFlags"
  '';
  makeFlags = "ICEBOX=${icestorm}/share/icebox";

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
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.shell ];
    platforms = stdenv.lib.platforms.linux;
  };
}
