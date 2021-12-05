{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "durden";
  version = "0.6.1+date=2021-10-17";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "5fb8b0f9bc2952ed9cf7dc20a1c5c0cc44c02ff1";
    hash = "sha256-+EIsrCkMe9MrUQOCh0R+rsDg/Rqs3iQWO0GZCgZQ+No=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/
    cp -a ./durden ${placeholder "out"}/share/arcan/appl/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://durden.arcan-fe.com/";
    description = "Reference Desktop Environment for Arcan";
    longDescription = ''
      Durden is a desktop environment for the Arcan Display Server. It serves
      both as a reference showcase on how to take advantage of some of the
      features in Arcan, and as a very competent entry to the advanced-user side
      of the desktop environment spectrum.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
