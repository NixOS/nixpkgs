{ lib, fetchurl }:

let
  pname = "agave";
  version = "15";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-Regular.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/Agave-Regular.ttf
  '';

  sha256 = "0xphr465qnwf1yhin3hml1nn9ypjk3n0i4bs38glx5b5swrhlmhk";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

