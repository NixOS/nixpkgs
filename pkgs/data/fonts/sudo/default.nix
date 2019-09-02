{ lib, fetchzip }:

let
  version = "0.37";
in fetchzip rec {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
  sha256 = "16x6vs016wz6rmd4p248ri9fn35xq7r3dc8hv4w2c4rz1xl8c099";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype/
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/
  '';
  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = https://www.kutilek.de/sudo-font/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

