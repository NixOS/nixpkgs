{ stdenv, fetchzip }:

let version = "1.0.0";
in fetchzip {
  name = "jetbrains-mono";
  url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";
  sha256 = "1znw1xihk4139bi1gacdpx5a3l3rpvhcmg3c2vwaj1g3kvhnyhnp";
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
