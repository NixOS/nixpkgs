{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nodejs_22,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "theme-forge-stellar-loom";
  version = "0.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/Knowledge-Forge-AI/theme-forge-stellar-loom/releases/download/v0.3.0/knowledge-forge-ai-theme-forge-stellar-loom-0.3.0.tgz";
    hash = "sha256-vwDudZVz+hezyBkbcxUKe4x4dJH7I6rIJfQRbi3VJHQ=";
  };

  sourceRoot = "package";
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    packageDir="$out/lib/node_modules/@knowledge-forge-ai/theme-forge-stellar-loom"
    mkdir -p "$packageDir" "$out/bin"
    cp -R . "$packageDir/"
    makeWrapper ${nodejs_22}/bin/node "$out/bin/tfsl" --add-flags "$packageDir/bin/tfsl.js"
    makeWrapper ${nodejs_22}/bin/node "$out/bin/tfsl-batch" --add-flags "$packageDir/bin/tfsl-batch.js"
    runHook postInstall
  '';

  meta = {
    description = "Starlight theme-builder backend, library, and CLI";
    homepage = "https://github.com/Knowledge-Forge-AI/theme-forge-stellar-loom";
    license = lib.licenses.agpl3Plus;
    mainProgram = "tfsl";
    platforms = lib.platforms.all;
  };
})
