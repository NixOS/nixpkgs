{ stdenv, fetchzip }:

let version = "1.0.0";
in fetchzip {
  name = "jetbrains-mono";
  url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";
  sha256 = "0mwqi66d56v4ml1w7wjsiidrh153jvh0czafyic47rkvmxhnrrhv";
  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "A monospace typeface for developers";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbuscarino ];
    platforms = platforms.all;
  };
}
