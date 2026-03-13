{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  yarn-berry,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vultisig-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vultisig";
    repo = "vultisig-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vpWoKxdiUSSI8xGYXmnduJnB3zB3jpBMxz+9eGXJgvM=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-ZJfLfaTvJKyCh4FtOs7IyZskBBjrJLjI0/9hphclFvU=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
    makeWrapper
  ];

  # Skip electron binary download; not needed for the CLI
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    # Build workspace dependencies needed by the CLI at runtime (SDK must come first)
    YARN_IGNORE_PATH=1 yarn workspace @vultisig/sdk build:platform:node
    YARN_IGNORE_PATH=1 yarn workspace @vultisig/sdk build:types
    YARN_IGNORE_PATH=1 yarn workspace @vultisig/rujira build
    YARN_IGNORE_PATH=1 yarn workspace @vultisig/cli build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vultisig-cli

    cp -r node_modules $out/lib/vultisig-cli/
    cp -r clients/cli/dist $out/lib/vultisig-cli/
    cp clients/cli/package.json $out/lib/vultisig-cli/

    # Remove broken symlinks (workspace packages that point into the monorepo)
    find $out/lib/vultisig-cli/node_modules -type l ! -exec test -e {} \; -delete

    # Copy built workspace packages that the CLI needs at runtime
    mkdir -p $out/lib/vultisig-cli/node_modules/@vultisig
    cp -rL packages/sdk $out/lib/vultisig-cli/node_modules/@vultisig/sdk
    cp -rL packages/rujira $out/lib/vultisig-cli/node_modules/@vultisig/rujira

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/vultisig \
      --add-flags "$out/lib/vultisig-cli/dist/index.js"

    runHook postInstall
  '';

  meta = {
    description = "Command-line wallet for Vultisig - multi-chain MPC wallet management";
    homepage = "https://vultisig.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RaghavSood ];
    mainProgram = "vultisig";
    platforms = lib.platforms.all;
  };
})
