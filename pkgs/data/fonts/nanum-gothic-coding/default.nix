# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "VER2.5";
  fullName = "NanumGothicCoding-2.5";

in (fetchzip {
  name = "nanum-gothic-coding";
  url = "https://github.com/naver/nanumfont/releases/download/${version}/${fullName}.zip";

  sha256 = "0b3pkhd6xn6393zi0dhj3ah08w1y1ji9fl6584bi0c8lanamf2pc";

  meta = with lib; {
    description = "A contemporary monospaced sans-serif typeface with a warm touch";
    homepage = "https://github.com/naver/nanumfont";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/NanumGothicCoding
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/NanumGothicCoding
  '';
})
