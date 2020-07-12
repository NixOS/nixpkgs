{ lib, fetchurl }:

let
  pname = "agave";
  version = "16";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-Regular.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/Agave-Regular.ttf
  '';

  sha256 = "108jvcijnx06v1jzhnb28ql9nvmwqd83309834wcd4aii6bgf9ka";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

