{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "medio";
  version = "0.200";

  src = fetchzip {
    url = "http://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "1d3hw6mfzfch1ikq9ay9db93z4cy1npfhhw1f0xmj69k7v09rq2b";
  };

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Serif font designed by Sora Sagano";
    longDescription = ''
      Medio is a serif font designed by Sora Sagano, based roughly
      on the proportions of the font Tenderness (from the same designer),
      but with hairline serifs in the style of a Didone.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
