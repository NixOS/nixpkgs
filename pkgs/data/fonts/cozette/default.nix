{ lib, fetchzip }:

let
  version = "1.8.3";
in
fetchzip rec {
  name = "Cozette-${version}";

  url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts.zip";

  sha256 = "1nc4zk6n7cbv9vwlhpm3ady5lc4d4ic1klyywwfg27w8j0jv57hx";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.bdf -d $out/share/fonts/misc
    unzip -j $downloadedFile \*.otb -d $out/share/fonts/misc
  '';

  meta = with lib; {
    description = "A bitmap programming font optimized for coziness.";
    homepage = "https://github.com/slavfox/cozette";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons marsam ];
  };
}
