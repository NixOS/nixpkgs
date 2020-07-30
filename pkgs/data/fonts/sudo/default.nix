{ lib, fetchzip }:

let
  version = "0.50";
in fetchzip {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/raw/v${version}/dist/sudo.zip";
  sha256 = "1mk81r9p7ks6av3rj06c6n9vx2qv2hwx6zfbc2mk1filxjirk1ll";

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

