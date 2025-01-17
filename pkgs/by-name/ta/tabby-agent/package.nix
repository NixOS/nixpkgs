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
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TP0KEGH8w9kdTj5yxCsAn4LRS1gj3Dnz96GA8DDSJJU=";
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
    hash = "sha256-fpzl2w0o5bJhppVUl6vRNqAVQNMPLK0+JX/KYEtUGGA=";
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
