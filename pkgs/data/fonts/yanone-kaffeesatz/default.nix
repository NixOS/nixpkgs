{ lib, mkFont, fetchzip }:

mkFont {
  pname = "yanone-kaffeesatz";
  version = "2004";

  src = fetchzip {
    url = "https://yanone.de/2015/data/UIdownloads/Yanone%20Kaffeesatz.zip";
    sha256 = "11hakl6j8gmjbapiyfik2jhasljgbqhsljzmygfbzvq9fpph287k";
    stripRoot = false;
  };

  meta = {
    description = "The free font classic";
    maintainers = with lib.maintainers; [ mt-caret ];
    platforms = with lib.platforms; all;
    homepage = "https://yanone.de/fonts/kaffeesatz/";
    license = lib.licenses.ofl;
  };
}
