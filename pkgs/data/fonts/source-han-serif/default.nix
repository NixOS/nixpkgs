{stdenv, fetchurl, unzip}:

let
  makePackage = {variant, language, region, sha256}: stdenv.mkDerivation rec {
    version = "1.000R";
    name = "source-han-serif-${variant}-${version}";
    revision = "f6cf97d92b22e7bd77e355a61fe549ae44b6de76";

    buildInputs = [ unzip ];

    src = fetchurl {
      url = "https://github.com/adobe-fonts/source-han-serif/raw/${revision}/SubsetOTF/SourceHanSerif${region}.zip";
      inherit sha256;
    };

    setSourceRoot = ''
      sourceRoot=$( echo SourceHanSerif* )
    '';

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp $( find . -name '*.otf' ) $out/share/fonts/opentype
    '';

    meta = {
      description = "${language} subset of an open source Pan-CJK serif typeface";
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
    sha256 = "0488zxr6jpwinzayrznc4ciy8mqcq9afx80xnp37pl9gcxsv0jp7";
  };
  korean = makePackage {
    variant = "korean";
    language = "Korean";
    region = "KR";
    sha256 = "1kwsqrb3s52nminq65n3la540dgvahnhvgwv5h168nrmz881ni9r";
  };
  simplified-chinese = makePackage {
    variant = "simplified-chinese";
    language = "Simplified Chinese";
    region = "CN";
    sha256 = "0y6js0hjgf1i8mf7kzklcl02qg0bi7j8n7j1l4awmkij1ix2yc43";
  };
  traditional-chinese = makePackage {
    variant = "traditional-chinese";
    language = "Traditional Chinese";
    region = "TW";
    sha256 = "0q52dn0vh3pqpr9gn4r4qk99lkvhf2gl12y99n9423brrqyfbi6h";
  };
}
