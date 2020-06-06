{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "5.5.0";

  src = fetchurl {
    url = "https://cdn.joypixels.com/arch-linux/font/${version}/joypixels-android.ttf";
    sha256 = "0w3r50l0knrncwv6zihyx01gs995y76xjcwsysx5bmvc1b43yijb";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/share/fonts/truetype/joypixels.ttf
  '';

  meta = with stdenv.lib; {
    description = "Emoji as a Service (formerly EmojiOne)";
    homepage = "https://www.joypixels.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar ];
  };
}
