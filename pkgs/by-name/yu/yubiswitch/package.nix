{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yubiswitch";
  version = "0.19";

  src = fetchurl {
    url = "https://github.com/pallotron/yubiswitch/releases/download/v${finalAttrs.version}/yubiswitch_${finalAttrs.version}.dmg";
    hash = "sha256-l010gbOI/nmwPx7qLDn0Wi90BRt3SkiaAOL+AMnfGzE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  # Fixup phases modify the binary and invalidate the code signature.
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R yubiswitch.app "$out/Applications"

    runHook postInstall
  '';

  meta = {
    description = "The macOS status bar application to enable/disable Yubikeys.";
    homepage = "https://github.com/pallotron/yubiswitch";
    changelog = "https://github.com/pallotron/yubiswitch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ sheeeng ];
  };
})
