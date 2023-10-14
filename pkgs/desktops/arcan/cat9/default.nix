{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "unstable-2023-02-11";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "cat9";
    rev = "1da9949c728e0734a883d258a8a05ca0e3dd5897";
    hash = "sha256-kit+H9u941oK2Ko8S/1w+3DN6ktnfBtd+3s9XgU+qOQ=";
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
