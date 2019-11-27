{ lib, fetchurl }:

let
  pname = "cascadia-code";
  version = "1911.20";
in
fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/Cascadia.ttf";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    install -Dm444 $downloadedFile $out/share/fonts/truetype/Cascadia.ttf
  '';

  sha256 = "1dfd3g7cf2h0z2gxvk4pxy46xswd3wyqz3p8ypxcv2dkz4ri6l0j";

  meta = with lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
