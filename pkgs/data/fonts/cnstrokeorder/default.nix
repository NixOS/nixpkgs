{ lib, mkFont, fetchurl }:

mkFont rec {
  pname = "cnstrokeorder";
  version = "0.0.4.7";

  src = fetchurl {
    url = "https://rtega.be/chmn/CNstrokeorder-${version}.ttf";
    sha256 = "11m416p3iciiqbpjldj945h2dmwn9bzvsgqbq01mvmgd9dqlx2v1";
  };

  noUnpackFonts = true;

  meta = with lib; {
    description = "Chinese font that shows stroke order for HSK 1-4";
    homepage = "https://rtega.be/chmn/index.php?subpage=68";
    license = [ licenses.arphicpl ];
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.all;
  };
}
