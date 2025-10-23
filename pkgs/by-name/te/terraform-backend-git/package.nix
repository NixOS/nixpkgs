{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "terraform-backend-git";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "plumber-cd";
    repo = "terraform-backend-git";
    rev = "v${version}";
    hash = "sha256-mZbGMv5b9wK/gWqQB75sDJIVURrS6t/L7WBhTonaatQ=";
  };

  vendorHash = "sha256-vFx59dIdniLRP0xHcD3c22GidZOPdGZvmvg/BvxFBGI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/plumber-cd/terraform-backend-git/cmd.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd terraform-backend-git \
      --bash <($out/bin/terraform-backend-git completion bash) \
      --fish <($out/bin/terraform-backend-git completion fish) \
      --zsh <($out/bin/terraform-backend-git completion zsh)
  '';

  meta = with lib; {
    description = "Terraform HTTP Backend implementation that uses Git repository as storage";
    mainProgram = "terraform-backend-git";
    homepage = "https://github.com/plumber-cd/terraform-backend-git";
    changelog = "https://github.com/plumber-cd/terraform-backend-git/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
