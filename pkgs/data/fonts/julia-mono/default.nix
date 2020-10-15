{ lib, fetchzip }:

let
  version = "0.021";
in fetchzip {
  name = "JuliaMono-${version}";
  url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono.zip";
  sha256 = "0i22p4frsnba2k7q5sj84mscxjfcbpf0v1gycd4qx7yp6pwmdlmy";

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
