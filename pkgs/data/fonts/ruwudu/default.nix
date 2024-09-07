{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "ruwudu";
  version = "3.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/ruwudu/Ruwudu-${version}.zip";
    hash = "sha256-HuuH6AWD5gym73zSsuQdQD901J6r3PkUmUTtnRxYRyg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{doc/${pname},fonts/truetype}
    mv *.ttf $out/share/fonts/truetype/
    mv *.txt documentation $out/share/doc/${pname}/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/ruwudu/";
    description = "Arabic script font for a style of writing used in Niger, West Africa";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}
