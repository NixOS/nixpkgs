{ lib, fetchzip }:

let
  version = "3.001";
in fetchzip rec {
  name = "comfortaa-${version}";

  url = "https://orig00.deviantart.net/40a3/f/2017/093/d/4/comfortaa___font_by_aajohan-d1qr019.zip";
  postFetch = ''
    mkdir -p $out/share/fonts $out/share/doc
    unzip -j $downloadedFile \*.ttf                        -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*/FONTLOG.txt \*/donate.html -d $out/share/doc/${name}
  '';
  sha256 = "0z7xr0cnn6ghwivrm5b5awq9bzhnay3y99qq6dkdgfkfdsaz0n9h";

  meta = with lib; {
    homepage = http://aajohan.deviantart.com/art/Comfortaa-font-105395949;
    description = "A clean and modern font suitable for headings and logos";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
