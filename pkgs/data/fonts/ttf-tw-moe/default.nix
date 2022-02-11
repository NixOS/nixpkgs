{ lib, fetchzip }:
let
  version = "2020-11-14";
in
fetchzip {
  name = "ttf-tw-moe";

  url = "https://github.com/Jiehong/TW-fonts/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile TW-fonts-${version}/\*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "1jd3gjjfa4vadp6d499n0irz5b22z611kd7q5qgqf6s2fwbxfhiz";

  meta = with lib; {
    homepage = "http://www.moe.gov.tw/";
    description = "Set of KAI and SONG fonts from the Ministry of Education of Taiwan";
    version = version;
    longDescription = ''
      Installs 2 TTF fonts: MOESongUN and TW-MOE-Std-Kai.
      Both are provided by the Ministry of Education of Taiwan; each character's shape
      closely follows the official recommendation, and can be used as for teaching purposes.
    '';
    license = licenses.cc-by-nd-30;
    maintainers = [ maintainers.jiehong ];
    platforms = platforms.all;
  };
}
