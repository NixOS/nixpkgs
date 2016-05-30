{ stdenv, fetchFromGitHub, icestorm }:

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2016.05.21";

  src = fetchFromGitHub {
    owner = "cseed";
    repo = "arachne-pnr";
    rev = "6b8336497800782f2f69572d40702b60423ec67f";
    sha256 = "11hg17f4lp8azc0ir0i473fz9c0dra82r4fn45cr3amd57v00qbf";
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
  };
}
