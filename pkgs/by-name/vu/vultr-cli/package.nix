{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "vultr-cli";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = "vultr-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uHH8Rx7zxmOvW+KWycffvZDu2AoX8geqWzDlGuntPx0=";
  };

  vendorHash = "sha256-NXNFbSk62B4DfaQCc6S3k2CqT6kJE0DGxZzDWMbeBxU=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd vultr-cli \
      --bash <($out/bin/vultr-cli completion bash) \
      --fish <($out/bin/vultr-cli completion fish) \
      --zsh <($out/bin/vultr-cli completion zsh)
  '';

  meta = {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    changelog = "https://github.com/vultr/vultr-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "vultr-cli";
  };
})
