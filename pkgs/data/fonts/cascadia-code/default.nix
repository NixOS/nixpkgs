{ lib, fetchzip }:
let
  version = "2007.01";
in
fetchzip {
  name = "cascadia-code-${version}";

  url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaCode-${version}.zip";

  sha256 = "173dpr0k4y5b02ps9426pyaazl2pxj1kw5l5jrikbi6zjv4590gb";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
