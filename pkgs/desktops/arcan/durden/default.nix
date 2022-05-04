{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "durden";
  version = "0.6.1+date=2022-03-11";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "fec2a1051500df28becce188d932645743091efa";
    hash = "sha256-uZ7oTnkWG3P/4ETgn6MQ9v47mRAJnvyzglQS7jlabPA=";
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
}
