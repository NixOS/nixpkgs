{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nodejs_22,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "theme-forge-solar-sail";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/Knowledge-Forge-AI/theme-forge-solar-sail/releases/download/v0.1.0/knowledge-forge-ai-theme-forge-solar-sail-0.1.0.tgz";
    hash = "sha256-E70mcQ877ZVVXgQKatLhPv2RQkQC7Ya+KTTIru0Y5oQ=";
  };

  sourceRoot = "package";
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    packageDir="$out/lib/node_modules/@knowledge-forge-ai/theme-forge-solar-sail"
    mkdir -p "$packageDir" "$out/bin"
    cp -R . "$packageDir/"
    makeWrapper ${nodejs_22}/bin/node "$out/bin/tfss" --add-flags "$packageDir/bin/tfss.js"
    runHook postInstall
  '';

  meta = {
    description = "Tailwind v4 and shadcn/ui application theme compiler and CLI";
    homepage = "https://github.com/Knowledge-Forge-AI/theme-forge-solar-sail";
    license = lib.licenses.agpl3Plus;
    mainProgram = "tfss";
    platforms = lib.platforms.all;
  };
})
