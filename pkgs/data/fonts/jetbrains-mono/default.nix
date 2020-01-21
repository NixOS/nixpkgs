{ lib, fetchzip }:

let
  version = "1.0.0";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";

  sha256 = "0mwqi66d56v4ml1w7wjsiidrh153jvh0czafyic47rkvmxhnrrhv";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype *.ttf
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
