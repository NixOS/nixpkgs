{ lib, mkFont, fetchurl }:

mkFont rec {
  pname = "unifont_upper";
  version = "12.1.03";

  src = fetchurl {
    url = "mirror://gnu/unifont/unifont-${version}/${pname}-${version}.ttf";
    sha256 = "0f12kf1vxajlm88sqj0dpw8vmfbx2r353yw0z3q138rla1zmd874";
  };

  noUnpackFonts = true;

  meta = with lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = "https://unifoundry.com/unifont.html";

    # Basically GPL2+ with font exception.
    license = "http://unifoundry.com/LICENSE.txt";
    platforms = platforms.all;
    maintainers = with maintainers; [ mathnerd314 vrthra ];
  };
}
