{ lib, mkFont, fetchurl }:

mkFont rec {
  pname = "Cozette";
  version = "1.5.1";

  srcs = map fetchurl [
    {
      url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/cozette.otb";
      sha256 = "05k45n7jar11gnng2awpmc7zk9jdlzd6wz87xx49cp75jm4z9xm8";
    }
    {
      url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteVector.otf";
      sha256 = "1sqhnjpizn1wi26lc7z2zml7yr7zkcpa72mh1drvd74rlcs1ip30";
    }
    {
      url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteVector.ttf";
      sha256 = "1q4ml8shv9lmyc6bwhffwvbvl92s73j7xkb0rkqvci4f0zbz7mcy";
    }
  ];

  noUnpackFonts = true;

  meta = with lib; {
    description = "A bitmap programming font optimized for coziness.";
    homepage = "https://github.com/slavfox/cozette";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons ];
  };
}
