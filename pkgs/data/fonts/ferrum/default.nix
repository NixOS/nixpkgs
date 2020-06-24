{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ferrum";
  version = "0.200";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "11s0fdiv313hfjvpgfx31q9jcslpg679amk4j162i0wran070cil";
  };

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "A decorative font.";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
