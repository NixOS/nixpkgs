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
    sha256 = "156m92k38ap4bzidbr8dzl065rni8lrib71ih88myk9z5y1x5nxm";
  };

  hardeningDisable = [ "fortify" ];

  installPhase = ''
    mkdir --parents "$out/bin"
    cp ./traceFileSim "$out/bin"
  '';

  meta = with lib; {
    description = "Ease the analysis of existing memory management techniques, as well as the prototyping of new memory management techniques";
    mainProgram = "traceFileSim";
    homepage = "https://github.com/GarCoSim";
    maintainers = [ maintainers.cmcdragonkai ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
