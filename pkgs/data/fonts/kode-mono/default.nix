{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kode-mono";
  version = "1.018";

  src = fetchzip {
    url = "https://github.com/isaozler/kode-mono/releases/download/${finalAttrs.version}/kode-mono-fonts.zip";
    hash = "sha256-ITz37lO0+bQd156WKBT8bcz8571kMiJGKepGCCVxaJU=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 kode-mono-fonts/fonts/ttf/*.ttf      -t $out/share/fonts/truetype/
    install -Dm644 kode-mono-fonts/fonts/variable/*.ttf -t $out/share/fonts/truetype/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A custom-designed typeface explicitly created for the developer community";
    homepage = "https://kodemono.com/";
    changelog = "https://github.com/isaozler/kode-mono/blob/main/CHANGELOG.md";
    license = licenses.ofl;
    maintainers = [ maintainers.isaozler ];
    platforms = platforms.all;
  };
})
