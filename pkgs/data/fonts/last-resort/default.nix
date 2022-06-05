{ lib, fetchurl }:

let
  version = "14.000";
in fetchurl {
  name = "last-resort-${version}";

  url = "https://github.com/unicode-org/last-resort-font/releases/download/${version}/LastResortHE-Regular.ttf";
  downloadToTemp = true;

  postFetch = ''
    install -D -m 0644 $downloadedFile $out/share/fonts/truetype/LastResortHE-Regular.ttf
  '';

  recursiveHash = true;
  sha256 = "sha256-rb69V4oExSFx4GpedpyVvGuS6o+MxmxTCSZhoe9kUhI=";

  meta = with lib; {
    description = "Fallback font of last resort";
    homepage = "https://github.com/unicode-org/last-resort-font";
    license = licenses.ofl;
    maintainers = with maintainers; [ V ];
  };
}
