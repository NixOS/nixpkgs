{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pipeworld";
  version = "0.pre+date=2021-11-26";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "9f816db154ca5c54af952ad11c2186ccac5bdd2d";
    hash = "sha256-uwnrRsMP0RLEGr2mEVQ6kEtV/c6t5qSCHY0ynywPzkw=";
  };

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
}
