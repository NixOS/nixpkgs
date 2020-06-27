{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "penna";
  version = "0.100";

  src = fetchzip {
    url = "http://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "170zhaxi65gq52avlnqiwflgi44vaar2gdwjyib6fl588sf8jq3y";
  };

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Geometric sans serif designed by Sora Sagano";
    longDescription = ''
     Penna is a geometric sans serif designed by Sora Sagano,
     with outsized counters in the uppercase and a lowercase
     with a small x-height.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
