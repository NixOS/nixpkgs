{ lib, fetchzip }:

let
  version = "0.42";
in fetchzip {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
  sha256 = "1rqpwihf2sakrhkaw041r3xc9fhafaqn22n79haqkmwv4vmnspch";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/
    unzip -j $downloadedFile \*.woff -d $out/share/fonts/woff/
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2/
  '';
  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

