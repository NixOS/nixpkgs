{ stdenv, fetchzip }:

fetchzip {
  name = "ttf-tw-moe";

  url = "https://github.com/Jiehong/TW-fonts/archive/b30ae75e9dc299afd61e31cfd43f7a0a157dfb1f.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile TW-fonts-b30ae75e9dc299afd61e31cfd43f7a0a157dfb1f/\*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "0khgxih9z6pqf7pdp21xjp24wb9ygsrdcmzpjb7vr9x8n78i1fbs";

  meta = with stdenv.lib; {
    homepage = "http://www.moe.gov.tw/";
    description = "Set of KAI and SONG fonts from the Ministry of Education of Taiwan";
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
