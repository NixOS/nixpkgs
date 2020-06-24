{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "source-sans-pro";
  version = "3.006";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-sans-pro/releases/download/${version}R/source-sans-pro-${version}R.zip";
    sha256 = "1asm5s68ay57wiq7aydcw4x0g3zg5lfk2gfza1p87p1a725ay9nm";
  };

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-sans-pro/";
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
