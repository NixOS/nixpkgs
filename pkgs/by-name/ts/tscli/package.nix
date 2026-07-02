{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "tscli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "tscli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vCRRPVQIMpVZr45dwKNCcA53j5lkGY8FvfXLmy/H5G8=";
  };

  vendorHash = "sha256-sVpwrdA30QklyFVdg+F1k27fbJFWIVCAJi+NN0XVQOw=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X=github.com/jaxxstorm/tscli/pkg/version.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tscli \
      --bash <($out/bin/tscli -k XXX completion bash) \
      --fish <($out/bin/tscli -k XXX completion fish) \
      --zsh <($out/bin/tscli -k XXX completion zsh)
  '';

  meta = {
    description = "CLI tool to interact with the Tailscale API";
    homepage = "https://github.com/jaxxstorm/tscli";
    changelog = "https://github.com/jaxxstorm/tscli/releases/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "tscli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
