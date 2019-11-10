{ lib, fetchzip }:

let
  version = "3.006";
in fetchzip {
  name = "source-sans-pro-${version}";

  url = "https://github.com/adobe-fonts/source-sans-pro/releases/download/${version}R/source-sans-pro-${version}R.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,variable}
    unzip -j $downloadedFile "*/OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "*/TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "*/VAR/*.otf" -d $out/share/fonts/variable
  '';

  sha256 = "11jd50cqiq2s0z39rclg73iiw2j5yzgs1glfs9psw5wbbisgysmr";

  meta = with lib; {
    homepage = https://adobe-fonts.github.io/source-sans-pro/;
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
