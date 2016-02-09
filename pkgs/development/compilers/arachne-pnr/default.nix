{ stdenv, fetchFromGitHub, icestorm }:

stdenv.mkDerivation rec {
  name = "arachne-pnr-${version}";
  version = "2015.12.29";

  src = fetchFromGitHub {
    owner = "cseed";
    repo = "arachne-pnr";
    rev = "1a4fdf96a7fd08806c032d41a2443c8e17c72c80";
    sha256 = "1dj7ycffwkmlsh12117fbybkdfnlhxbbxkbfgwfyvcgmg3cacgl1";
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
