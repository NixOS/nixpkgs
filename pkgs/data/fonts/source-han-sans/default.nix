{stdenv, fetchurl}:

let
  makePackage = {language, region, description}: stdenv.mkDerivation rec {
    version = "1.001R";
    name = "source-han-sans-${language}-${version}";

    src = fetchurl {
      url = "https://github.com/adobe-fonts/source-han-sans/archive/${version}.tar.gz";
      sha256 = "0cwz3d8jancl0a7vbjxhnh1vgwsjba62lahfjya9yrjkp1ndxlap";
    };

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp $( find SubsetOTF/${region} -name '*.otf' ) $out/share/fonts/opentype
    '';

    meta = {
      inherit description;

      homepage = https://github.com/adobe-fonts/source-han-sans;
      license = stdenv.lib.licenses.asl20;
    };
  };
in
{
  japanese = makePackage {
    language = "japanese";
    region = "JP";
    description = "Japanese subset of an open source Pan-CJK typeface";
  };
  korean = makePackage {
    language = "korean";
    region = "KR";
    description = "Korean subset of an open source Pan-CJK typeface";
  };
  simplified-chinese = makePackage {
    language = "simplified-chinese";
    region = "CN";
    description = "Simplified Chinese subset of an open source Pan-CJK typeface";
  };
  traditional-chinese = makePackage {
    language = "traditional-chinese";
    region = "TW";
    description = "Traditional Chinese subset of an open source Pan-CJK typeface";
  };
}
