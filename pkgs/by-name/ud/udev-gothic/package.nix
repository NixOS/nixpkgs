{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "udev-gothic";
  version = "2.1.0";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${finalAttrs.version}/UDEVGothic_v${finalAttrs.version}.zip";
    hash = "sha256-9gwBT0GVNPVWoiFIKBUf5sNGkhfJCWhMFRRIGvj5Wto=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/udev-gothic
    runHook postInstall
  '';

  meta = {
    description = "Programming font that combines BIZ UD Gothic and JetBrains Mono";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ haruki7049 ];
    platforms = lib.platforms.all;
  };
})
