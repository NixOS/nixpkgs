{ lib, fetchzip }:

let
  version = "0.019";

in fetchzip rec {
  name = "juliamono-${version}";

  url = "https://github.com/cormullion/juliamono/releases/download/v${version}/JuliaMono.tar.gz";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    tar -xzvf $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype *.ttf
  '';
  sha256 = "1s21vjdyfbwki73sxw1bdiqs8y2s6xkra4hsgl3lz6r921z0rgh6";

  meta = with lib; {
    homepage = "https://juliamono.netlify.app/";
    description = "monospaced font for scientific and technical computing";
    longDescription = ''
      JuliaMono is a monospaced typeface designed for programming in the Julia Programming Language and in other text editing environments that require a wide range of specialist and technical Unicode characters. It was intended as an experiment to be presented at the 2020 JuliaCon conference in Lisbon, Portugal (which of course didn’t happen).

      JuliaMono is:

      - free
      - distributed with a liberal licence
      - suitable for scientific and technical programming as well as for general purpose hacking
      - easy to use, simple, friendly, and approachable
    '';
    license = licenses.ofl;
    maintainers = with maintainers; [ toastal ];
    platforms = platforms.all;
  };
}

