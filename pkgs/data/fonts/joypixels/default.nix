{ stdenv, fetchurl }:

let inherit (stdenv.hostPlatform) system;

    throwSystem = throw "Unsupported system: ${system}";

    systemTag = {
      x86_64-darwin = "nix-darwin";
      x86_64-linux = "nix-os";
    }.${system} or throwSystem;

    capitalized = {
      x86_64-darwin = systemTag;
      x86_64-linux = "NixOS";
    }.${system} or throwSystem;

    fontFile = {
      x86_64-darwin = "Apple%20Color%20Emoji.ttc";
      x86_64-linux = "joypixels-android.ttf";
    }.${system} or throwSystem;

    name = {
      x86_64-darwin = "joypixels-apple-color-emoji.ttc";
      x86_64-linux = fontFile;
    }.${system} or throwSystem;

    ext = {
      x86_64-darwin = "ttc";
      x86_64-linux = "ttf";
    }.${system} or throwSystem;

    sha256 = {
      x86_64-darwin = "043980g0dlp8vd4qkbx6298fwz8ns0iwbxm0f8czd9s7n2xm4npq";
      x86_64-linux = "1vxqsqs93g4jyp01r47lrpcm0fmib2n1vysx32ksmfxmprimb75s";
    }.${system} or throwSystem;

in

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "6.0.0";

  src = fetchurl {
    inherit name sha256;
    url = "https://cdn.joypixels.com/distributions/${systemTag}/font/${version}/${fontFile}";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/share/fonts/truetype/joypixels.${ext}
  '';

  meta = with stdenv.lib; {
    description = "The finest emoji you can use legally (formerly EmojiOne)";
    longDescription = ''
      New for 2020! JoyPixels 6.0 includes 3,342 originally crafted icon
      designs and is 100% Unicode 13 compatible. We offer the largest selection
      of files ranging from png, svg, iconjar, sprites, and fonts.
    '';
    homepage = "https://www.joypixels.com/fonts";
    license = licenses.unfree;
    maintainers = with maintainers; [ toonn jtojnar ];
  };
}
