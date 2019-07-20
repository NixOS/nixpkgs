{ lib, fetchurl }:

let
  pname = "agave";
  version = "10";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/agarick/agave/releases/download/v${version}/agave-r.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/agave-r.ttf
  '';

  sha256 = "1mfj6a9sp00mjz7420yyrbbs5bqks3fz2slwgcppklxnz0890r9f";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = https://b.agaric.net/page/agave;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

