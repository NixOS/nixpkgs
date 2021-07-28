{ lib, fetchzip }:

let
  version = "2.241";
in
fetchzip {
  name = "JetBrainsMono-${version}";

  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";

  sha256 = "1gwhbmq8zw026i66g96i75zn2zff7cr83ns8aaslrzsrkk247lah";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    changelog = "https://github.com/JetBrains/JetBrainsMono/blob/v${version}/Changelog.md";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
