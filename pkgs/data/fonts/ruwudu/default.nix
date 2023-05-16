{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "ruwudu";
<<<<<<< HEAD
  version = "3.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/ruwudu/Ruwudu-${version}.zip";
    hash = "sha256-HuuH6AWD5gym73zSsuQdQD901J6r3PkUmUTtnRxYRyg=";
=======
  version = "2.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/ruwudu/Ruwudu-${version}.zip";
    hash = "sha256-FP+ZHm1fKlozAAI2PbJ4r4v5OwRxBtYMRLmRwPbqx2I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
