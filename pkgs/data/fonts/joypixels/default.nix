{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "5.0.2";

  src = fetchurl {
    url = "https://cdn.joypixels.com/arch-linux/font/${version}/joypixels-android.ttf";
    sha256 = "0javgnfsh2nfddr5flf4yzi81ar8wx2z8w1q7h4fvdng5fsrgici";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/share/fonts/truetype/joypixels.ttf
  '';

  meta = with stdenv.lib; {
    description = "Emoji as a Service (formerly EmojiOne)";
    homepage = https://www.joypixels.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar ];
  };
}
