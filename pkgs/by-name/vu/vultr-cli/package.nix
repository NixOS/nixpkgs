{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "vultr-cli";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = "vultr-cli";
    rev = "v${version}";
    hash = "sha256-qBl3fduyPKw+R6X5EguVGUkKKGD+XbJH30CdRroEV4M=";
  };

  vendorHash = "sha256-JrIJ/8l+TWXEdFtrnS1fCEyEb89/nixjr3Y7/R+iqBI=";

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
