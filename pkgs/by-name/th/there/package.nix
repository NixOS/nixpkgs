{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "there";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/dena-sohrabi/There/releases/download/v${finalAttrs.version}/There.zip";
    hash = "sha256-p7AK9FfeycUgDfVk8HlKkjLBdOoTWAK/oGxlWSFykOc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R There.app "$out/Applications/"

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Track timezones";
    homepage = "https://there.pm";
    changelog = "https://github.com/dena-sohrabi/There/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ myzel394 ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
