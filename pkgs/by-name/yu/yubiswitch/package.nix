{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yubiswitch";
  version = "0.18";

  src = fetchurl {
    url = "https://github.com/pallotron/yubiswitch/releases/download/v${finalAttrs.version}/yubiswitch_${finalAttrs.version}.dmg";
    hash = "sha256-ee7l8jj1pJdj+SjMNWcLfHV//G0FG9bdBkNcxUh8Zuk=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R yubiswitch.app "$out/Applications"

    runHook postInstall
  '';

  meta = {
    description = "macOS status bar application to enable/disable a Yubikey Nano";
    homepage = "https://github.com/pallotron/yubiswitch";
    changelog = "https://github.com/pallotron/yubiswitch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ sheeeng ];
  };
})
