{ lib, mkFont, fetchzip }:

mkFont {
  pname = "source-code-pro";
  version = "2.030";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip";
    sha256 = "0hc5kflr8xzqgdm0c3gbgb1paygznxmnivkylid69ipc7wnicx1n";
  };

  meta = {
    description = "A set of monospaced OpenType fonts designed for coding environments";
    maintainers = with lib.maintainers; [ relrod ];
    platforms = with lib.platforms; all;
    homepage = "https://adobe-fonts.github.io/source-code-pro/";
    license = lib.licenses.ofl;
  };
}
