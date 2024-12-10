{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jost";
  version = "3.5";

  src = fetchzip {
    url = "https://github.com/indestructible-type/Jost/releases/download/${version}/Jost.zip";
    hash = "sha256-ne81bMhmTzNZ/GGIzb7nCYh19vNLK+hJ3cP/zDxtiGM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/indestructible-type/Jost";
    description = "A sans serif font by Indestructible Type";
    license = licenses.ofl;
    maintainers = [ maintainers.ar1a ];
  };
}
