{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalPackages: {
  pname = "cat9";
  version = "unstable-2018-09-13";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = finalPackages.pname;
    rev = "754d9d2900d647a0fa264720528117471a32f295";
    hash = "sha256-UmbynVOJYvHz+deA99lj/BBFOauZzwSNs+qR28pASPY=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/cat9
    cp -a ./* ${placeholder "out"}/share/arcan/appl/cat9

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/letoram/cat9";
    description = "A User shell for LASH";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
})
