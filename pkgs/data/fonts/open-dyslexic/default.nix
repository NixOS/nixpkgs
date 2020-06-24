{ lib, mkFont, fetchzip }:

mkFont {
  pname = "open-dyslexic";
  version = "2016-06-23";

  src = fetchzip {
    url = "https://github.com/antijingoist/open-dyslexic/archive/20160623-Stable.zip";
    sha256 = "0nr7s92nk1kbr459154idnib977ixc70z6g9mbra3lp73nyrmyvz";
  };

  meta = with lib; {
    homepage = "https://opendyslexic.org/";
    description = "Font created to increase readability for readers with dyslexia";
    license = "Bitstream Vera License (https://www.gnome.org/fonts/#Final_Bitstream_Vera_Fonts)";
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
