{ stdenv, fetchFromGitHub, icestorm }:

with builtins;

stdenv.mkDerivation rec {
  pname = "arachne-pnr";
  version = "2019.07.29";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "arachne-pnr";
    rev    = "c40fb2289952f4f120cc10a5a4c82a6fb88442dc";
    sha256 = "0lg9rccr486cvips3jf289af2b4a2j9chc8iqnkhykgi1hw4pszc";
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
