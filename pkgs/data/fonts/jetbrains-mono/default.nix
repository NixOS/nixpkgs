{ lib, fetchzip }:

let
  version = "2.210";
in
fetchzip {
  name = "JetBrainsMono-${version}";

  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";

  sha256 = "05csy42qji8xbaq5iap2nmki0d0cbiwiq9kbzjd1cah9qn6gfill";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
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
