{
  lib,
  fetchzip,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "whisky";
  version = "2.3.5";

  src = fetchzip {
    extension = "zip";
    name = "Whisky.app";
    url = "https://github.com/IsaacMarovitz/Whisky/releases/download/v${finalAttrs.version}/Whisky.zip";
    hash = "sha256-tETDj83dCZJdJCGpXyK6pdhwr70sYWCknBHybMAWHzU=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wine wrapper built with SwiftUI";
    homepage = "https://getwhisky.app/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iivusly ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
