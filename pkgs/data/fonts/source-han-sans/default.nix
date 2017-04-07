{stdenv, fetchurl, unzip}:

let
  makePackage = {variant, language, region, sha256}: stdenv.mkDerivation rec {
    version = "1.004R";
    name = "source-han-sans-${variant}-${version}";
    revision = "5f5311e71cb628321cc0cffb51fb38d862b726aa";

    buildInputs = [ unzip ];

    src = fetchurl {
      url = "https://github.com/adobe-fonts/source-han-sans/raw/${revision}/SubsetOTF/SourceHanSans${region}.zip";
      inherit sha256;
    };

    setSourceRoot = ''
      sourceRoot=$( echo SourceHanSans* )
    '';

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp $( find . -name '*.otf' ) $out/share/fonts/opentype
    '';

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
    sha256 = "0m1zprwqnqp3za42firg53hyzir6p0q73fl8mh5j4px3zgivlvfw";
  };
  korean = makePackage {
    variant = "korean";
    language = "Korean";
    region = "KR";
    sha256 = "1bz6n2sd842vgnqky0i7a3j3i2ixhzzkkbx1m8plk04r1z41bz9q";
  };
  simplified-chinese = makePackage {
    variant = "simplified-chinese";
    language = "Simplified Chinese";
    region = "CN";
    sha256 = "0ksafcwmnpj3yxkgn8qkqkpw10ivl0nj9n2lsi9c6fw3aa71s3ha";
  };
  traditional-chinese = makePackage {
    variant = "traditional-chinese";
    language = "Traditional Chinese";
    region = "TW";
    sha256 = "1l4zymd5n4nl9gmja707xq6bar88dxki2mwdixdfrkf544cidflj";
  };
}
