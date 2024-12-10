{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "alkalami";
  version = "3.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/alkalami/Alkalami-${version}.zip";
    hash = "sha256-ra664VbUKc8XpULCWhLMVnc1mW4pqZvbvwuBvRQRhcY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{doc/${pname},fonts/truetype}
    mv *.ttf $out/share/fonts/truetype/
    mv *.txt documentation $out/share/doc/${pname}/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/alkalami/";
    description = "A font for Arabic-based writing systems in the Kano region of Nigeria and in Niger";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}
