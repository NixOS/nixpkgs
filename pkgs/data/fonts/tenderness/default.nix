{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "tenderness";
  version = "0.601";
  # for compatibility
  name = "${pname}-font-${version}";

  src = fetchzip {
    url = "http://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "03175rkbcy7mv9b4gwfliyq4r94mv2hh74hhlkvgmvyqx9dll0kg";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Serif font designed by Sora Sagano with old-style figures";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
