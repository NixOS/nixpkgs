{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "cozette";
  version = "1.23.1";

  src = fetchzip {
    url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts-v-${builtins.replaceStrings ["."] ["-"] version}.zip";
    hash = "sha256-LbC5siSxDZnOEkfxeqOSyoaDuTEMG2xCpZaOZrHLTJo=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.otf -t $out/share/fonts/opentype
    install -Dm644 *.bdf -t $out/share/fonts/misc
    install -Dm644 *.otb -t $out/share/fonts/misc
    install -Dm644 *.woff -t $out/share/fonts/woff
    install -Dm644 *.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "A bitmap programming font optimized for coziness";
    homepage = "https://github.com/slavfox/cozette";
    changelog = "https://github.com/slavfox/Cozette/blob/v.${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons marsam ];
  };
}
