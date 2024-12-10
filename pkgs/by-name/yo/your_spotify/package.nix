{
  callPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  makeWrapper,
  mkYarnPackage,
  nodejs,
  fixup-yarn-lock,
  yarn,
}:
let
  version = "1.10.1";
  src = fetchFromGitHub {
    owner = "Yooooomi";
    repo = "your_spotify";
    rev = "refs/tags/${version}";
    hash = "sha256-e82j2blGxQLWAlBNuAnFvlD9vwMk4/mRI0Vf7vuaPA0=";
  };
  client = callPackage ./client.nix { inherit src version; };
in
mkYarnPackage rec {
  inherit version src;
  pname = "your_spotify_server";
  name = "your_spotify_server-${version}";
  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-5SgknaRVzgO2Dzc8MhAaM8UERWMv+PrItzevoWHbWnA=";
  };

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    pushd ./apps/server/
    yarn --offline run build
    popd

    rm -r node_modules
    export NODE_ENV="production"
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postBuild
  '';
  nativeBuildInputs = [
    makeWrapper
    yarn
    fixup-yarn-lock
  ];
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
  doDist = false;
  passthru = {
    inherit client;
  };
  meta = with lib; {
    homepage = "https://github.com/Yooooomi/your_spotify";
    changelog = "https://github.com/Yooooomi/your_spotify/releases/tag/${version}";
    description = "Self-hosted application that tracks what you listen and offers you a dashboard to explore statistics about it";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ patrickdag ];
    mainProgram = "your_spotify_server";
  };
}
