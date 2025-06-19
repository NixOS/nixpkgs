{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "zerocool_ttf";
  version = "1.0";

  src = fetchurl {
    url = "https://dl.dafont.com/dl/?f=zero_cool";
    hash = "sha256-wpB5YdOlYcRLSGou1Wjk+oRGrwSiiL+f6BQNp/VUQe4=";
    name = "zero_cool.zip";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = {
    description = "Playful bold display typeface";
    homepage = "https://ggbot.itch.io/zero-cool-font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ gigahawk ];
  };
}