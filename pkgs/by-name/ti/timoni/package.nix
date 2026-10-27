{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

# Requires Go 1.27; switch back to buildGoModule once the default is updated.
buildGo127Module (finalAttrs: {
  pname = "timoni";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZS8ebKFxqEWuZD98tqyWOC/AocSXhHctFZ7kSAfPHdQ=";
  };

  vendorHash = "sha256-PmN6zdxNJFleB3CVjOxI/AMglVEmzqtr4dYSLG3HKWY=";

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
