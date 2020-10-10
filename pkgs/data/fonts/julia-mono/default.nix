{ lib, fetchzip }:

let
  version = "0.018";
in fetchzip {
  name = "JuliaMono-${version}";
  url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono.zip";
  sha256 = "0ss79a9gymbhih5pgjkg1mipmk0qsvqqwlkqcdm9fz87d7kfhby3";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = {
    description = "A monospaced font for scientific and technical computing";
    maintainers = with lib.maintainers; [ suhr ];
    platforms = with lib.platforms; all;
    homepage = "https://juliamono.netlify.app/";
    license = lib.licenses.ofl;
  };
}
