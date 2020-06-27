{ lib, mkFont, fetchurl }:

mkFont rec {
  pname = "agave";
  version = "14";

  src = fetchurl {
    url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-Regular.ttf";
    sha256 = "0n47xfg5grdvbxnygim5yz6qi8vy2bgk99xhns2pq6psb670yn4h";
  };

  noUnpackFonts = true;

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

