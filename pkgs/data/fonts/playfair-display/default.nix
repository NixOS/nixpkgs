{ lib, fetchFromGitHub }:

let
  version = "unstable-2021-10-10";
  pname = "playfair-display";
in fetchFromGitHub rec {
  rev = "7ae68c5da1c379fec062735cd702473fe3fb11f6";
  name = "${pname}-${version}";
  owner = "clauseggers";
  repo = "Playfair-Display";
  sha256 = "KYiC3TNV8361VNKvMtkGATf4X/uIVAp9MqyuLMWm0sI=";

  postFetch = ''
    tar -xf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp */fonts/TTF/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    homepage = "https://github.com/clauseggers/Playfair-Display";
    description = "An Open Source typeface family for display and titling use";
    longDescription = ''
      Playfair is a transitional design. As the name indicates, Playfair
      Display is well suited for titling and head­lines.

      Playfair includes a full set of small-caps, common ligatures, and
      discretionary ligatures. For Polish, a set of alternate diacritical
      characters designed with ‘kreska’s are included. All European lan­guages using
      the latin script are supported. A set of eight arrow devices are also
      included.

      Playfair Display also cover the cyrillic glyphs used in Bulgarian,
      Belarusian, Russian, Bosnian/Serbian (including Serbian morphology for б),
      and Ukrainian.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
