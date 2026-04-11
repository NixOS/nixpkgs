{
  lib,
  fetchurl,
  stdenv,
  undmg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "syncthing-macos";
  version = "2.0.14-1";

  src = fetchurl {
    url = "https://github.com/syncthing/syncthing-macos/releases/download/v${finalAttrs.version}/Syncthing-${finalAttrs.version}.dmg";
    hash = "sha256-5BjYwS2xcANqEXWadbppUwIGNd1UTQjzhWIAyATwWEU=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Syncthing.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/${finalAttrs.sourceRoot}
    cp -R . $out/Applications/${finalAttrs.sourceRoot}

    runHook postInstall
  '';

  updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

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
