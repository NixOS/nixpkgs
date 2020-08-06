{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  pname = "joypixels";
  version = "6.0.0";

  url = {
    x86_64-darwin = "https://cdn.joypixels.com/distributions/nix-darwin/font/6.0.0/Apple%20Color%20Emoji.ttc";
    x86_64-linux = "https://cdn.joypixels.com/distributions/nix-os/font/${version}/joypixels-android.ttf";
  }.${system} or throwSystem;

  name = {
    x86_64-darwin = "joypixels-apple-color-emoji.ttc";
    x86_64-linux = "joypixels-android.ttf";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-darwin = "043980g0dlp8vd4qkbx6298fwz8ns0iwbxm0f8czd9s7n2xm4npq";
    x86_64-linux = "1vxqsqs93g4jyp01r47lrpcm0fmib2n1vysx32ksmfxmprimb75s";
  }.${system} or throwSystem;

  src = fetchurl {
    inherit url name sha256;
  };

  dontUnpack = true;

  installPhase = {
    x86_64-darwin = ''
      install -Dm644 $src $out/share/fonts/truetype/joypixels.ttc
    '';
    x86_64-linux = ''
      install -Dm644 $src $out/share/fonts/truetype/joypixels.ttf
    '';
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "Emoji as a Service (formerly EmojiOne)";
    homepage = "https://www.joypixels.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ toonn jtojnar ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
