{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "sitelen-seli-kiwen";
  version = "unstable-2022-06-28";

  src = fetchzip {
    url = "https://raw.githubusercontent.com/kreativekorp/sitelen-seli-kiwen/69132c99873894746c9710707aaeb2cea2609709/sitelenselikiwen.zip";
    stripRoot = false;
    hash = "sha256-viOLAj9Rn60bcQkkDHVuKHCE8KPnIz/L0hIJhum1SSQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype}
    mv *.eot $out/share/fonts/opentype/
    mv *.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A handwritten sitelen pona font supporting UCSUR";
    homepage = "https://www.kreativekorp.com/software/fonts/sitelenselikiwen/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ somasis ];
  };
}
