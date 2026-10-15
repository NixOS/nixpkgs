{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {

  pname = "tracefilesim";
  version = "unstable-2015-11-07";

  src = fetchFromGitHub {
    owner = "GarCoSim";
    repo = "TraceFileSim";
    rev = "368aa6b1d6560e7ecbd16fca47000c8f528f3da2";
    hash = "sha256-tdvSgy8/TV8RgjGcFTNF0eZiAP0N5dXiX+QqNKZI1ZQ=";
  };

  hardeningDisable = [ "fortify" ];

  installPhase = ''
    mkdir --parents "$out/bin"
    cp ./traceFileSim "$out/bin"
  '';

  meta = {
    description = "Ease the analysis of existing memory management techniques, as well as the prototyping of new memory management techniques";
    mainProgram = "traceFileSim";
    homepage = "https://github.com/GarCoSim";
    maintainers = [ lib.maintainers.cmcdragonkai ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };

}
