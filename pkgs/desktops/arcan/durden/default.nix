{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "durden";
  version = "unstable-2023-01-19";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "durden";
    rev = "bba1bcc8992ea5826fd3b1c798cb271141b7c8e2";
    hash = "sha256-PK9ObMJ3SbHZLnLjxk4smh5N0WaM/2H/Y+T5vKBdHWA=";
  };

  dontConfigure = true;

  dontBuild = true;

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
})
