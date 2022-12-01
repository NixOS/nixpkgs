{ lib, fetchzip }:

let
  version = "0.046";

in
fetchzip {
  name = "JuliaMono-ttf-${version}";
  url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono-ttf.tar.gz";
  sha256 = "sha256-+Ro517m1unQskQFhsT6oiz19aov87/tT1jlP/XB7kFU=";

  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf $out/share/fonts/truetype
    rm $out/LICENSE
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
