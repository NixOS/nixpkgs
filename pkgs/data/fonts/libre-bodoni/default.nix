{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "libre-bodoni";
  version = "2.000";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Libre-Bodoni";
    rev = "995a40e8d6b95411d660cbc5bb3f726ffd080c7d";
    sha256 = "1ncfkvmcxh2lphfra43h8482qglpd965v96agvz092697xwrbyn9";
  };

  sourceRoot = "source/fonts/v2000 - initial glyphs migration";

  meta = with lib; {
    description = "Bodoni fonts adapted for today's web requirements";
    longDescription = ''
      The Libre Bodoni fonts are based on the 19th century Morris Fuller
      Benton's ATF design, but specifically adapted for today's web
      requirements.

      They are a perfect choice for everything related to elegance, style,
      luxury and fashion.

      Libre Bodoni currently features four styles: Regular, Italic, Bold and
      Bold Italic.
    '';
    homepage = "https://github.com/impallari/Libre-Bodoni";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
