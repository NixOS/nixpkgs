{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "unstable-2023-06-25";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "cat9";
    rev = "4d8a0c539a5c756acada96fd80e7eb3b9554ac05";
    hash = "sha256-T3RPuldKTzHm0EdfdMOtHv9kcr9oE9YQgdzv/jjPPnc=";
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
    license = licenses.unlicense;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
})
