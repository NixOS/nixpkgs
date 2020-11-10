{ lib, fetchurl }:

let
  pname = "agave";
  version = "30";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-Regular.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/Agave-Regular.ttf
  '';

  sha256 = "1f2f1fycwi8xbf8x03yfq78nv11b2msl4ll9flw8rkg023h9vwg7";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

