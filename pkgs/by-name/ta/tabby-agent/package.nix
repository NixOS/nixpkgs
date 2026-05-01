{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  wrapGAppsHook3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tabby-agent";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OeHRJOg7UEOVBG7jTUGCpiuKZI0Jj7Gl7QDKpsjX5Bc=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_9
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

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-xx45vudeW6OnUgyH0N+gQI5GPT8k5B4x0HdCvHF+f9A=";
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
    maintainers = [ ];
  };
})
