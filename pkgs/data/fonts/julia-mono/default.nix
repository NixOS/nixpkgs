{ lib, fetchzip }:

let
  version = "0.022";
in fetchzip {
  name = "JuliaMono-${version}";
  url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono.zip";
  sha256 = "sha256-/MVT6n842sSiuPZNYxN3q1vn6yvMvmcTEDyvAd2GikA=";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
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
