{ lib, mkFont, fetchurl }:

mkFont {
  pname = "pecita";
  version = "5.4";

  src = fetchurl {
    url = "http://pecita.eu/b/Pecita.otf";
    sha256 = "1ppajx60hqpr51iaa8dxqan7lk5z5wzfr7nrnw6pa50lkvx1klhg";
  };

  noUnpackFonts = true;

  meta = with lib; {
    homepage = "http://pecita.eu/police-en.php";
    description = "Handwritten font with connected glyphs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ rycee ];
  };
}
