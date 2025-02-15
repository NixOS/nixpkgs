{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_9,
  wrapGAppsHook3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tabby-agent";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8SUeqIta1CFLVtX7GxOeczSDyi50TTGgyZK2kZJsA+0=";
  };

  nativeBuildInputs = [
    pnpm_9.configHook
    wrapGAppsHook3
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter=tabby-agent build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./clients/tabby-agent/dist $out/dist
    ln -s $out/dist/node/index.js $out/bin/tabby-agent
    chmod +x $out/bin/tabby-agent

    runHook postInstall
  '';

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-fQnMLjVhscLN0HFyP7ArjytTryZtr1D+gxrvMT0c40k=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    homepage = "https://github.com/TabbyML/tabby";
    changelog = "https://github.com/TabbyML/tabby/releases/tag/v${finalAttrs.version}";
    description = "Language server used to communicate with Tabby server";
    mainProgram = "tabby-agent";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.khaneliman ];
  };
})
