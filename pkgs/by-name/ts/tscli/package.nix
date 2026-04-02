{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "tscli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "tscli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zOl+AXVEUPJtEcptT1ApIs+3Fq19XZGY3JFVUAGciEg=";
  };

  vendorHash = "sha256-bH8jYaA/54s2q9KgqEBHaPPwXJg/ch1ksKRvyEiMMmA=";

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
