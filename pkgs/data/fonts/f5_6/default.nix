{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "f5_6";
  version = "0.110";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "1qfykpdhd8br9yrg4icn7wdfj6wysijyyj1cnswj7lnidkx99q0m";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "A weighted decorative font.";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
