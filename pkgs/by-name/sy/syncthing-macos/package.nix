{
  lib,
  fetchurl,
  stdenv,
  undmg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "syncthing-macos";
  version = "1.29.2-2";

  src = fetchurl {
    url = "https://github.com/syncthing/syncthing-macos/releases/download/v${finalAttrs.version}/Syncthing-${finalAttrs.version}.dmg";
    hash = "sha256-KbUpc2gymxkhkpSvIpy2fF3xAKsDqHHwlfUB8BF8+Sc=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Syncthing.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/${finalAttrs.sourceRoot}
    cp -R . $out/Applications/${finalAttrs.sourceRoot}

    runHook postInstall
  '';

  meta = {
    description = "Official frugal and native macOS Syncthing application bundle";
    homepage = "https://github.com/syncthing/syncthing-macos";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Enzime ];
    hydraPlatforms = [ ]; # no building required
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
