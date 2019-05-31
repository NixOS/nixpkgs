{ lib, fetchurl }:

let
  version = "0.0.4.7";
in fetchurl {
  name = "cnstrokeorder-${version}";

  url = "http://rtega.be/chmn/CNstrokeorder-${version}.ttf";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/CNstrokeorder-${version}.ttf
  '';

  sha256 = "0cizgfdgbq9av5c8234mysr2q54iw9pkxrmq5ga8gv32hxhl5bx4";

  meta = with lib; {
    description = "Chinese font that shows stroke order for HSK 1-4";
    homepage = "http://rtega.be/chmn/index.php?subpage=68";
    license = [ licenses.arphicpl ];
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.all;
  };
}
