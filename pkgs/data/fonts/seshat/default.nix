{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "seshat";
  version = "0.100";

  src = fetchzip {
    url = "http://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "0r1v626zjm0az162k6cq2xiaqfwz8853p40dczrw8vf03h76n2jy";
  };

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "Roman body font designed for main text by Sora Sagano";
    longDescription = ''
      Seshat is a Roman body font designed for the main text. By
      referring to the classical balance, we changed some lines by
      omitting part of the lines such as "A" and "n".

      Also, by attaching the strength of the thickness like Optima
      to the main drawing, it makes it more sharp design.

      It incorporates symbols and ligatures used in the European region.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
