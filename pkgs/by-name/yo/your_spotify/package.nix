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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "your_spotify_server";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "Yooooomi";
    repo = "your_spotify";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-e82j2blGxQLWAlBNuAnFvlD9vwMk4/mRI0Vf7vuaPA0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-5SgknaRVzgO2Dzc8MhAaM8UERWMv+PrItzevoWHbWnA=";
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
      inherit (finalAttrs) src version offlineCache meta;
    };
    tests = {
      inherit (nixosTests) your_spotify;
    };
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
