{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "fantasque-sans-mono";
  version = "1.8.0";

  src = fetchzip {
    url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono-Normal.zip";
    sha256 = "0msql67gndixnw3pvhb1c5kfzbg9ylqh15bi3mbqrnz26fhdkm9h";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://github.com/belluzj/fantasque-sans";
    description = "A font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
