{
  fetchzip,
  lib,
  pkgs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "traccar";
  version = "6.9.1";
  nativeBuildInputs = [ pkgs.makeWrapper ];

  src = fetchzip {
    stripRoot = false;
    url = "https://github.com/traccar/traccar/releases/download/v${version}/traccar-other-${version}.zip";
    hash = "sha256-PR0crdEGYr4lVp5JSFSLGsR+uZKWulfp6LA57y9K88E=";
  };

  installPhase = ''
    runHook preInstall

    for dir in lib schema templates web ; do
      mkdir -p $out/$dir
      cp -a $dir $out
    done

    mkdir -p $out/share/traccar
    install -Dm644 tracker-server.jar $out

    makeWrapper ${pkgs.openjdk}/bin/java $out/bin/traccar \
      --add-flags "-jar $out/tracker-server.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source GPS tracking system";
    homepage = "https://www.traccar.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    mainProgram = "traccar";
    maintainers = with maintainers; [ frederictobiasc ];
  };
}
