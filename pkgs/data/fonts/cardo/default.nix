{ fetchzip, lib }:

let
  version = "1.04";
in
fetchzip {
  name = "cardo-${version}";

  url = "http://scholarsfonts.net/cardo104.zip";

  hash = "sha256-eBK6+VQpreWA7jIneNXOcKFcT+cJzhoQ9XXyq93SZ8M=";
  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf $out/share/fonts/truetype
    rm $out/*.pdf
  '';

  meta = with lib; {
    description = "Cardo is a large Unicode font specifically designed for the needs of classicists, Biblical scholars, medievalists, and linguists";
    longDescription = ''
      Cardo is a large Unicode font specifically designed for the needs of
      classicists, Biblical scholars, medievalists, and linguists. It also
      works well for general typesetting in situations where a high-quality Old
      Style font is appropriate. Its large character set supports many modern
      languages as well as those needed by scholars. Cardo also contains
      features that are required for high-quality typography such as ligatures,
      text figures (also known as old style numerals), true small capitals and
      a variety of punctuation and space characters.
    '';
    homepage = "http://scholarsfonts.net/cardofnt.html";
    license = licenses.ofl;
    maintainers = with lib.maintainers; [ kmein ];
    platforms = platforms.all;
  };
}
