{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "eunomia";
  version = "0.200";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${pname}_${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "0vhl46s8n5h5r71ghz05jn0dgxl3w1sb8d2x27l3qnlk8rm89pa5";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://dotcolon.net/font/eunomia/";
    description = "A futuristic decorative font.";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
