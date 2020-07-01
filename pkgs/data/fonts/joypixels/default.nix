{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "6.0.0";

  src = fetchurl {
    url = "https://cdn.joypixels.com/arch-linux/font/${version}/joypixels-android.ttf";
    sha256 = "1vxqsqs93g4jyp01r47lrpcm0fmib2n1vysx32ksmfxmprimb75s";
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
