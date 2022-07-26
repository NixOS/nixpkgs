{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "durden";
  version = "0.6.1+date=2022-05-23";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "9284182bd8b3b976387cd6494c5f605633a559fc";
    hash = "sha256-K1MjgNyX6qlaHya6Grej0cagORihS35BWECWn2HcRCk=";
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
