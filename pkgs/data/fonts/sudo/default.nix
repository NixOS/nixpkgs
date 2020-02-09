{ lib, fetchzip }:

let
  version = "0.41";
in fetchzip {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
  sha256 = "055sz9jg3fg7ypk9nia4dl9haaaq3w8zx5c2cdi3iq9kj8k5gg53";

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

