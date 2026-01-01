{
  fetchzip,
  lib,
  pkgs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "traccar";
<<<<<<< HEAD
  version = "6.11.1";
=======
  version = "6.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ pkgs.makeWrapper ];

  src = fetchzip {
    stripRoot = false;
    url = "https://github.com/traccar/traccar/releases/download/v${version}/traccar-other-${version}.zip";
<<<<<<< HEAD
    hash = "sha256-IYdcLOTGPoAs8Rg5WcYOMctOiY7icpvoVKLF7BhMTBY=";
=======
    hash = "sha256-esXmcN3j7rZ6Sx9n772LC39hN25tHKq7RIn+j/PyISw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Open source GPS tracking system";
    homepage = "https://www.traccar.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    mainProgram = "traccar";
    maintainers = with lib.maintainers; [ frederictobiasc ];
=======
  meta = with lib; {
    description = "Open source GPS tracking system";
    homepage = "https://www.traccar.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    mainProgram = "traccar";
    maintainers = with maintainers; [ frederictobiasc ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
