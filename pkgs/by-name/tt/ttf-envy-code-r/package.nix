{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ttf-envy-code-r";
  version = "PR7";

  src = fetchzip {
    url = "https://download.damieng.com/fonts/original/EnvyCodeR-${version}.zip";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.txt -t $out/share/doc/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://damieng.com/blog/tag/envy-code-r";
    description = "Free scalable coding font by DamienG";
    license = licenses.unfree;
    maintainers = [ ];
  };
}
