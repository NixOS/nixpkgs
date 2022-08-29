{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalPackages: {
  pname = "pipeworld";
  version = "unstable-2022-04-03";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "pipeworld";
    rev = "f60d0b93fcd5462f47b1c928c109f5b4cbd74eef";
    hash = "sha256-PNziP5LaUODZwtAHvg8uYt/EyoD3mB5aWIfp7n5a82E=";
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
