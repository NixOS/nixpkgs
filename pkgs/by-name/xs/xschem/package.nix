{
  stdenv,
  fetchFromGitHub,
  lib,
  bison,
  cairo,
  flex,
  libx11,
  libxpm,
  pkg-config,
  tcl,
  tk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xschem";
  version = "3.4.7";

  src = fetchFromGitHub {
    owner = "StefanSchippers";
    repo = "xschem";
    rev = finalAttrs.version;
    hash = "sha256-ye97VJQ+2F2UbFLmGrZ8xSK9xFeF+Yies6fJKurPOD0=";
  };

  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    cairo
    libx11
    libxpm
    tcl
    tk
  ];

  hardeningDisable = [ "format" ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Schematic capture and netlisting EDA tool";
    longDescription = ''
      Xschem is a schematic capture program, it allows creation of
      hierarchical representation of circuits with a top down approach.
      By focusing on interfaces, hierarchy and instance properties a
      complex system can be described in terms of simpler building
      blocks. A VHDL or Verilog or Spice netlist can be generated from
      the drawn schematic, allowing the simulation of the circuit.
    '';
    homepage = "https://xschem.sourceforge.io/stefan/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.platforms.all;
  };
})
