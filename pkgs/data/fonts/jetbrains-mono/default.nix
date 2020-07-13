{ lib, fetchzip }:

let
  version = "2.000";
in
fetchzip {
  name = "JetBrainsMono-${version}";

  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrains.Mono.${version}.zip";

  sha256 = "1kmb0fckiwaphqxw08xd5fbfjrwnwxz48bidj16ixw8lgcr29b8g";

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
