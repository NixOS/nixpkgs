{ lib, fetchzip }:

let
  version = "2.002";
in
fetchzip {
  name = "JetBrainsMono-${version}";

  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";

  sha256 = "018lhxi9m8aprls6cnpndzdg5snijwzm22m2pxxi6zcqxrcxh8vb";

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
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
