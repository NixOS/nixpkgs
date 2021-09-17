{ lib, fetchzip }:

let
  version = "0.042";

in
fetchzip {
  name = "JuliaMono-ttf-${version}";
  url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono-ttf.tar.gz";
  sha256 = "sha256-oXODkeLDT5GXO4+r1fGaRrRS/SSBhzro5XE0GOwl4mQ=";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    tar xf $downloadedFile -C $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A monospaced font for scientific and technical computing";
    longDescription = ''
      JuliaMono is a monospaced typeface designed for use in text editing
      environments that require a wide range of specialist and technical Unicode
      characters. It was intended as a fun experiment to be presented at the
      2020 JuliaCon conference in Lisbon, Portugal (which of course didn’t
      physically happen in Lisbon, but online).
    '';
    maintainers = with maintainers; [ suhr ];
    platforms = with platforms; all;
    homepage = "https://juliamono.netlify.app/";
    license = licenses.ofl;
  };
}
