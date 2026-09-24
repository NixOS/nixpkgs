{
  lib,
  stdenv,
  buildGoLatestModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoLatestModule (finalAttrs: {
  pname = "timoni";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PJZow1tS/WU7dKQpQF3sWrL2jilffAMq3w0Gfku8i/8=";
  };

  vendorHash = "sha256-cubKaujkC6pK34aHRKR4Oa85FVDA/DCae4CLLT8yZlA=";

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
