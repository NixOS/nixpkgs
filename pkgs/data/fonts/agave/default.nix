{ lib, fetchurl }:

let
  pname = "agave";
  version = "009";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/agarick/agave/releases/download/v${version}/agave-r.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/agave-r.ttf
  '';

  sha256 = "16qvz3zpwiq2nw0gxygva5pssswcia5xp0q6ir5jfkackvqf3fql";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = https://b.agaric.net/page/agave;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

