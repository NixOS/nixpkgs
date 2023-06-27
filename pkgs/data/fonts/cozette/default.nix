{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "cozette";
  version = "1.19.2";

  src = fetchzip {
    url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts.zip";
    hash = "sha256-+TnKUgrAafR5irS9XeXWfb1a2PfUKOXf8CAmqJbf6y4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.otf -t $out/share/fonts/opentype
    install -Dm644 *.bdf -t $out/share/fonts/misc
    install -Dm644 *.otb -t $out/share/fonts/misc

    runHook postInstall
  '';

  meta = with lib; {
    description = "A bitmap programming font optimized for coziness";
    homepage = "https://github.com/slavfox/cozette";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons marsam ];
  };
}
