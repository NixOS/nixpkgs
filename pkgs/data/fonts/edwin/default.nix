{ lib, fetchurl }:

let
  version = "0.52";
in fetchurl {
  name = "edwin-${version}";

  url = "https://github.com/MuseScoreFonts/Edwin/archive/refs/tags/v${version}.tar.gz";

  downloadToTemp = true;

  recursiveHash = true;

  sha256 = "sha256-e0ADK72ECl+QMvLWtFJfeHBmuEwzr9M+Kqvkd5Z2mmo=";

  postFetch = ''
    tar xzf $downloadedFile
    mkdir -p $out/share/fonts/opentype
    install Edwin-${version}/*.otf $out/share/fonts/opentype
  '';

  meta = with lib; {
    description = "A text font for musical scores";
    homepage = "https://github.com/MuseScoreFonts/Edwin";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
