{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  makeWrapper,
  callPackage,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "your_spotify_server";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "Yooooomi";
    repo = "your_spotify";
    tag = finalAttrs.version;
    hash = "sha256-i/R5tvt+9DD/ZUPLBq6EOJjuyHSv5zljTWuLwo+JBYA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-2Z5bOiPenlDTzOAMrIt73k4pi0v3SAN7HXXJDoOo8Qc=";
  };

  nativeBuildInputs = [
    makeWrapper
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  preBuild = ''
    pushd ./apps/server/
  '';
  postBuild = ''
    popd
    rm -r node_modules
    export NODE_ENV="production"
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/your_spotify
    cp -r node_modules $out/share/your_spotify/node_modules
    rm $out/share/your_spotify/node_modules/@your_spotify/{client,dev,server}
    cp -r ./apps/server/{lib,package.json} $out
    mkdir -p $out/bin
    makeWrapper ${lib.escapeShellArg (lib.getExe nodejs)} "$out/bin/your_spotify_migrate" \
      --add-flags "$out/lib/migrations.js" --set NODE_PATH "$out/share/your_spotify/node_modules"
    makeWrapper ${lib.escapeShellArg (lib.getExe nodejs)} "$out/bin/your_spotify_server" \
      --add-flags "$out/lib/index.js" --set NODE_PATH "$out/share/your_spotify/node_modules"

    runHook postInstall
  '';

  passthru = {
    client = callPackage ./client.nix {
      inherit (finalAttrs)
        src
        version
        offlineCache
        meta
        ;
    };
    tests = {
      inherit (nixosTests) your_spotify;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/Yooooomi/your_spotify";
    changelog = "https://github.com/Yooooomi/your_spotify/releases/tag/${finalAttrs.version}";
    description = "Self-hosted application that tracks what you listen and offers you a dashboard to explore statistics about it";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ patrickdag ];
    mainProgram = "your_spotify_server";
  };
})
