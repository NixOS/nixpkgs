{stdenv, fetchzip}:

let
  makePackage = {variant, language, region, sha256}: let
    version = "1.004R";
    revision = "5f5311e71cb628321cc0cffb51fb38d862b726aa";
  in fetchzip {
    name = "source-han-sans-${variant}-${version}";

    url = "https://github.com/adobe-fonts/source-han-sans/raw/${revision}/SubsetOTF/SourceHanSans${region}.zip";

    postFetch = ''
      mkdir -p $out/share/fonts
      unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    '';

    inherit sha256;

    meta = {
      description = "${language} subset of an open source Pan-CJK sans-serif typeface";
      homepage = https://github.com/adobe-fonts/source-han-sans;
      license = stdenv.lib.licenses.ofl;
      platforms = stdenv.lib.platforms.unix;
      maintainers = with stdenv.lib.maintainers; [ taku0 ];
    };
  };
in
{
  japanese = makePackage {
    variant = "japanese";
    language = "Japanese";
    region = "JP";
    sha256 = "194zapswaqly8ycx3k66vznlapvpyhdigp3sabsl4hn87j9xsc5v";
  };
  korean = makePackage {
    variant = "korean";
    language = "Korean";
    region = "KR";
    sha256 = "0xij6mciiqgpwv1agqily2jji377x084k7fj4rpv6z0r5vvhqr08";
  };
  simplified-chinese = makePackage {
    variant = "simplified-chinese";
    language = "Simplified Chinese";
    region = "CN";
    sha256 = "038av18d45qr85bgx95j2fm8j64d72nsm9xzg0lpwr9xwni2sbx0";
  };
  traditional-chinese = makePackage {
    variant = "traditional-chinese";
    language = "Traditional Chinese";
    region = "TW";
    sha256 = "1mzcv5hksyxplyv5q3w5nr1xz73hdnvip5gicz35j0by4gc739lr";
  };
}
