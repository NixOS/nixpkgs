{ lib, fetchurl }:

let
  pname = "cascadia-code";
  version = "1909.16";
in
fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/Cascadia.ttf";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    install -Dm444 $downloadedFile $out/share/fonts/truetype/Cascadia.ttf
  '';

  sha256 = "0nckczvak3pd1h3fiz0j827pm87px9swx60q07lc2jnjlxcghgl2";

  meta = with lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
