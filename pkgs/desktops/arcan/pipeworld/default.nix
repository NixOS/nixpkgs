{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalPackages: {
  pname = "pipeworld";
  version = "unstable-2023-02-05";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "pipeworld";
    rev = "58b2e9fe15ef0baa4b04c27079bfa386ec62b28e";
    hash = "sha256-PbKejghMkLZdeQJD9fObw9xhGH24IX72X7pyjapTXJM=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/
    cp -a ./pipeworld ${placeholder "out"}/share/arcan/appl/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/letoram/pipeworld";
    description = "Dataflow 'spreadsheet' desktop environment";
    longDescription = ''
      Pipeworld is a zooming dataflow tool and desktop heavily inspired by
      userland. It is built using the arcan desktop engine.

      It combines the programmable processing of shell scripts and pipes, the
      interactive visual addressing/programming model of spread sheets, the
      scenegraph- and interactive controls-, IPC- and client processing- of
      display servers into one model with zoomable tiling window management.

      It can be used as a standalone desktop of its own, or as a normal
      application within another desktop as a 'substitute' for your normal
      terminal emulator.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
})
