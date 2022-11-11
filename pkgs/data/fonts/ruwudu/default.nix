{ lib, fetchzip }:

fetchzip rec {
  pname = "ruwudu";
  version = "2.000";

  url = "https://software.sil.org/downloads/r/ruwudu/Ruwudu-${version}.zip";

  postFetch = ''
    rm -rf $out/web $out/manifest.json
    mkdir -p $out/share/{doc/${pname},fonts/truetype}
    mv $out/*.ttf $out/share/fonts/truetype/
    mv $out/*.txt $out/documentation $out/share/doc/${pname}/
  '';

  sha256 = "sha256-JCvVPbAFBWHL2eEnEUSgdTZ+Vkw3wkS3aS85xQZKNQs=";

  meta = with lib; {
    homepage = "https://software.sil.org/ruwudu/";
    description = "Arabic script font for a style of writing used in Niger, West Africa";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}
