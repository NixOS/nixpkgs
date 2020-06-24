{ lib, mkFont, fetchFromGitHub }:

mkFont {
  pname = "ia-writer-duospace";
  version = "20180721";

  src = fetchFromGitHub {
    owner = "iaolo";
    repo = "iA-Fonts";
    rev = "55edf60f544078ab1e14987bc67e9029a200e0eb";
    sha256 = "1582n676gbwjrblmcshyb1x9rc02njf84j1ija2vnb084wwz69zy";
  };

  meta = with lib; {
    description = "iA Writer Duospace Typeface";
    homepage = "https://ia.net/topics/in-search-of-the-perfect-writing-font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
