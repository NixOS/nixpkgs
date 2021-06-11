{ lib, fetchzip }:

let
  version = "0.53.1";
in fetchzip {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/raw/v${version}/dist/sudo.zip";
  sha256 = "1jil43j9ngz4422m76x67bafvxz75rncqqi57xd7fdxgcff7i8dp";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/
  '';
  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    changelog = "https://github.com/jenskutilek/sudo-font/raw/v${version}/sudo/FONTLOG.txt";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
