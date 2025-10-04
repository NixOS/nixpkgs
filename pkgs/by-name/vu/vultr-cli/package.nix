{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "vultr-cli";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = "vultr-cli";
    rev = "v${version}";
    hash = "sha256-6uVMy7FogacaJOtedly5kg7Gt55WSIhPLF2zGbM3LbE=";
  };

  vendorHash = "sha256-YPAlOC+8hxjtc4q4VQ+f0C/CpO1nGvEvuR2FOA34b08=";

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
    changelog = "https://github.com/vultr/vultr-cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "vultr-cli";
  };
}
