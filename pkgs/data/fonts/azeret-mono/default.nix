{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "azeret-mono";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "displaay";
    repo = "Azeret";
    rev = "3d45a6c3e094f08bfc70551b525bd2037cac51ba";
    hash = "sha256-WC5a2O+/hdX+lLz81obcmq64wYpX48ZxsYPEaZUbFaY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/ttf/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Azeret Mono";
    longDescription = ''
      The story of the typeface began with a draft that was driven by an exploration of OCR fonts, past and futuristic operating systems, various interfaces and the nineties. The final result is more based on a desire to achieve an appearance of the typeface that could serve in operating systems. Thus the overall character is a conjunction of everything described with details that evoke a specific personality.

      Azeret is a sans-serif typeface with a mono-linear character. Don’t go looking for too much contrast in the strokes! The circular parts of the letters do not have a smooth connection to the stems. The x-height is higher than usual and thus the ascenders and descenders are short. Alternates are also available which open the possibility of creating different moods. A number of them hint at a nineties aesthetic.

      The monospaced sub-family is available for free and is also on Google Fonts. If you would like to explore Azeret more you can do it on our micro-site which we developed with Martin Ehrlich.

      Designer: Martin Vácha, Daniel Quisek
      Production: Renegade Fonts (Jan Charvát, Zuzana Konečná)
    '';
    homepage = "https://displaay.net/typeface/azeret/azeret-mono/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ _21eleven ];
  };
}
