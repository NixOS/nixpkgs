{ lib, fetchurl }:

let
  pname = "agave";
  version = "17";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-Regular.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/Agave-Regular.ttf
  '';

  sha256 = "1h61j1nbiwip71gxmz8my6xwy0j8ahf2p39hmrl1rxpsqvsj6dlz";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

