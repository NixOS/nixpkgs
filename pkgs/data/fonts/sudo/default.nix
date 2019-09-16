{ lib, fetchzip }:

let
  version = "0.40";
in fetchzip {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
  sha256 = "1nf025sjps4yysf6zkns5fzjgls6xdpifh7bz4ray9x8h5pz0z64";

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

