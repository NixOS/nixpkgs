{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "vollkorn";
  version = "4.105";

  src = fetchzip {
    url = "http://vollkorn-typeface.com/download/vollkorn-${builtins.replaceStrings ["."] ["-"] version}.zip";
    stripRoot = false;
    hash = "sha256-oG79GgCwCavbMFAPakza08IPmt13Gwujrkc/NKTai7g=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/{doc/${pname}-${version},fonts/{opentype,truetype,WOFF,WOFF2}}
    cp -v {Fontlog,OFL-FAQ,OFL}.txt $out/share/doc/${pname}-${version}/
    cp -v PS-OTF/*.otf $out/share/fonts/opentype
    cp -v TTF/*.ttf $out/share/fonts/truetype
    cp -v WOFF/*.woff $out/share/fonts/WOFF
    cp -v WOFF2/*.woff2 $out/share/fonts/WOFF2

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://vollkorn-typeface.com/";
    description = "The free and healthy typeface for bread and butter use";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.schmittlauch ];
  };
}
