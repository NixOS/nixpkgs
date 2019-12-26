{ lib, fetchurl }:

let
  pname = "cascadia-code";
  version = "1911.21";
in
fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/Cascadia.ttf";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    install -Dm444 $downloadedFile $out/share/fonts/truetype/Cascadia.ttf
  '';

  sha256 = "0b41xkpqx4ybpw5ar8njy0yznbk0hwf1ypigxf8f16chsfim7dkr";

  meta = with lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
