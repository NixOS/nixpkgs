{ stdenv, fetchzip }:

let
  version = "2016-03-03";
in fetchzip {
  name = "shrikhand-${version}";

  url = https://github.com/jonpinhorn/shrikhand/raw/c11c9b0720fba977fad7cb4f339ebacdba1d1394/build/Shrikhand-Regular.ttf;

  postFetch = "install -D -m644 $downloadedFile $out/share/fonts/truetype/Shrikhand-Regular.ttf";

  sha256 = "0s54k9cs1g2yz6lwg5gakqb12vg5qkfdz3pc8mh7mib2s6q926hs";

  meta = with stdenv.lib; {
    homepage = https://jonpinhorn.github.io/shrikhand/;
    description = "A vibrant and playful typeface for both Latin and Gujarati writing systems";
    maintainers = with maintainers; [ sternenseemann ];
    platforms = platforms.all;
    license = licenses.ofl;
  };
}
