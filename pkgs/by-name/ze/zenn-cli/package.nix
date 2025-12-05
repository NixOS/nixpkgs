{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  pnpm_10,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zenn-cli";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "zenn-dev";
    repo = "zenn-editor";
    tag = finalAttrs.version;
    hash = "sha256-H46wFDSxG5Fg9HuJOLulBXoXR+osf4gJEa+ZMUMWT5Q=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
    makeWrapper
  ];

  pnpmWorkspaces = [ "zenn-cli..." ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 1;
    hash = "sha256-QEOGL/FK0Vq8opPu7NeTTrk/rwWlMgisx+A7edMN9fw=";
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
