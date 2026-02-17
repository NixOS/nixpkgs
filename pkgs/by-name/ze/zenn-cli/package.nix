{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zenn-cli";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "zenn-dev";
    repo = "zenn-editor";
    tag = finalAttrs.version;
    hash = "sha256-wItKDLAJHIyxUUaLIFM+sNYWtXKWC4P6GkCKn2Wh2JA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
    makeWrapper
  ];

  pnpmWorkspaces = [ "zenn-cli..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    hash = "sha256-WXsS5/J08n/dWV5MbyX4vK7j1mfiUoLdzwmzyqoX3FA=";
  };

  preBuild = ''
    echo VITE_EMBED_SERVER_ORIGIN="https://embed.zenn.studio" > packages/zenn-cli/.env
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build --no-daemon

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/packages}
    rm -r node_modules packages/zenn-cli/node_modules
    pnpm install --filter=zenn-cli --prod --ignore-scripts
    cp -r node_modules $out/lib
    cp -r packages/zenn-cli $out/lib/packages/zenn-cli

    makeWrapper "${lib.getExe nodejs}" "$out/bin/zenn" \
      --add-flags "$out/lib/packages/zenn-cli/dist/server/zenn.js"

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Preview Zenn content locally";
    homepage = "https://github.com/zenn-dev/zenn-editor";
    changelog = "https://github.com/zenn-dev/zenn-editor/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "zenn";
    platforms = nodejs.meta.platforms;
  };
})
