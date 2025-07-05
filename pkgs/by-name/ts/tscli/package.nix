{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tscli";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "tscli";
    tag = "v${version}";
    hash = "sha256-GJkFiofMO9dMFDqISzp/ewH5hxpp04o/dXJ/XNUZk74=";
  };

  vendorHash = "sha256-a/1I1enzmtVY/js7w/cCLTts8lGmMKMiCowH0Hr+xdM=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X=github.com/jaxxstorm/tscli/pkg/version.Version=${version}"
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
    changelog = "https://github.com/jaxxstorm/tscli/releases/tag/${src.tag}/CHANGELOG.md";
    mainProgram = "tscli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
