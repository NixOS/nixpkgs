{stdenv, fetchzip}:

let
  makePackage = {variant, language, region, sha256}: let
    version = "1.000R";
    revision = "f6cf97d92b22e7bd77e355a61fe549ae44b6de76";
  in fetchzip {
    name = "source-han-serif-${variant}-${version}";

    url = "https://github.com/adobe-fonts/source-han-serif/raw/${revision}/SubsetOTF/SourceHanSerif${region}.zip";

    postFetch = ''
      mkdir -p $out/share/fonts/opentype
      unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    '';

    inherit sha256;

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
    sha256 = "0cklcy6y3r7pg8z43fzd8zl5g46bkqa1iy0li49rm0fgdaw7kin2";
  };
  korean = makePackage {
    variant = "korean";
    language = "Korean";
    region = "KR";
    sha256 = "0lxrr978djsych8fmbl57n1c9c7ihl61w0b9q4plw27vd6p41fza";
  };
  simplified-chinese = makePackage {
    variant = "simplified-chinese";
    language = "Simplified Chinese";
    region = "CN";
    sha256 = "0k3x4kncjnbipf4i3lkk6b33zpf1ckp5648z51v48q47l3zqpm6p";
  };
  traditional-chinese = makePackage {
    variant = "traditional-chinese";
    language = "Traditional Chinese";
    region = "TW";
    sha256 = "00bi66nlkrargmmf4av24qfd716py7a9smcvr4xnll7fffldxv06";
  };
}
