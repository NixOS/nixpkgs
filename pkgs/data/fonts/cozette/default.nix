{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.5.1";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "05k45n7jar11gnng2awpmc7zk9jdlzd6wz87xx49cp75jm4z9xm8";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "1sqhnjpizn1wi26lc7z2zml7yr7zkcpa72mh1drvd74rlcs1ip30";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "1q4ml8shv9lmyc6bwhffwvbvl92s73j7xkb0rkqvci4f0zbz7mcy";
    }
  ];

  nativeBuildInputs = [ mkfontscale ];

  sourceRoot = "./";

  unpackCmd = ''
    otName=$(stripHash "$curSrc")
    cp $curSrc ./$otName
  '';

  installPhase = ''

    install -D -m 644 *.otf -t "$out/share/fonts/opentype"
    install -D -m 644 *.ttf -t "$out/share/fonts/truetype"
    install -D -m 644 *.otb -t "$out/share/fonts/misc"

    mkfontdir "$out/share/fonts/misc"
    mkfontscale "$out/share/fonts/truetype"
    mkfontscale "$out/share/fonts/opentype"
  '';

  outputs = [ "out" ];

  meta = with stdenv.lib; {
    description = "A bitmap programming font optimized for coziness.";
    homepage = "https://github.com/slavfox/cozette";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons ];
  };
}
