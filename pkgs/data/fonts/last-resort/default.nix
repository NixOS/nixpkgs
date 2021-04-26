{ lib, fetchurl }:

let
  version = "13.001";
in fetchurl {
  name = "last-resort-${version}";

  url = "https://github.com/unicode-org/last-resort-font/releases/download/${version}/LastResortHE-Regular.ttf";
  downloadToTemp = true;

  postFetch = ''
    install -D -m 0644 $downloadedFile $out/share/fonts/truetype/LastResortHE-Regular.ttf
  '';

  recursiveHash = true;
  sha256 = "08mi65j46fv6a3y3pqnglqdjxjnbzg25v25f7c1zyk3c285m14hq";

  meta = with lib; {
    description = "Fallback font of last resort";
    homepage = "https://github.com/unicode-org/last-resort-font";
    license = licenses.ofl;
    maintainers = with maintainers; [ V ];
  };
}
