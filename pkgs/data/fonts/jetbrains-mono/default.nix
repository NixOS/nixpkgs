{ lib, fetchzip }:

let
  version = "1.0.4";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";

  sha256 = "1m6wppz6mrh7475d92yvwrjgbwkkcfq444v0im90f5c7fsf3dzbd";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.eot -d $out/share/fonts/eot
    unzip -j $downloadedFile \*.woff -d $out/share/fonts/woff
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
