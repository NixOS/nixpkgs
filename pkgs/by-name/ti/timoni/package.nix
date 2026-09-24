{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "timoni";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Is5IRJhzHcPv5pQ76CqiFSuEWO642BS36E6W1qckB9k=";
  };

  vendorHash = "sha256-kqmFRvVfohVBKeC1T13LVqX3AAbJT3aABhkMkLjFzAA=";

  subPackages = [ "cmd/timoni" ];
  nativeBuildInputs = [ installShellFiles ];

  # Some tests require running Kubernetes instance
  doCheck = false;

  ldflags = [
    "-s"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd timoni \
    --bash <($out/bin/timoni completion bash) \
    --fish <($out/bin/timoni completion fish) \
    --zsh <($out/bin/timoni completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://timoni.sh";
    changelog = "https://github.com/stefanprodan/timoni/releases/tag/v${finalAttrs.version}";
    description = "Package manager for Kubernetes, powered by CUE and inspired by Helm";
    mainProgram = "timoni";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ votava ];
  };
})
