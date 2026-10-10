{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "elm-watch";
  version = "1.2.8";

  inherit nodejs;

  src = fetchFromGitHub {
    owner = "lydell";
    repo = "elm-watch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AosI/d9sFHI/vRXNE0xNwsewYeSntfgpgAEwyu0isns=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-zZsddyXGff3mKGAhg0az41I27mH0TApkRU38KBf8bQM=";

  npmFlags = [ "--ignore-scripts" ];

  dontNpmInstall = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    local moduleDir="$out/lib/node_modules/elm-watch"
    mkdir -p "$moduleDir"

    npm prune --omit=dev --ignore-scripts --no-save
    cp -r build/. "$moduleDir/"
    cp -r node_modules "$moduleDir/"

    mkdir -p "$out/bin"
    makeWrapper ${nodejs}/bin/node "$out/bin/elm-watch" \
      --add-flags "$moduleDir/index.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`elm make` in watch mode. Fast and reliable";
    homepage = "https://github.com/lydell/elm-watch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Myxogastria0808 ];
    mainProgram = "elm-watch";
  };
})
