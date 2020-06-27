{ lib, mkFont, fetchurl }:

mkFont {
  pname = "shrikhand";
  version = "2016-03-03";

  src = fetchurl {
    url = "https://github.com/jonpinhorn/shrikhand/raw/c11c9b0720fba977fad7cb4f339ebacdba1d1394/build/Shrikhand-Regular.ttf";
    sha256 = "1h0h78q15fb6x8jmw29jzjx2f6xnwrx3h0qwz7d0sqxr1c3zawy0";
  };

  noUnpackFonts = true;

  meta = with lib; {
    homepage = "https://jonpinhorn.github.io/shrikhand/";
    description = "A vibrant and playful typeface for both Latin and Gujarati writing systems";
    maintainers = with maintainers; [ sternenseemann ];
    platforms = platforms.all;
    license = licenses.ofl;
  };
}
