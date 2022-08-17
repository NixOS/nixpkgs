{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalPackages: {
  pname = "durden";
  version = "unstable-2022-07-16";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "durden";
    rev = "4c9eaf1550d34e10565b545e0f96b1f6b8d26dcd";
    hash = "sha256-1d+Kg17nxNQeVT/iVa5oPXu96Ivvas9AO/H+NxhB4Yo=";
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
