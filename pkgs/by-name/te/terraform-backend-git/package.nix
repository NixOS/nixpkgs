{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-backend-git";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "plumber-cd";
    repo = "terraform-backend-git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hOHNUgRFb2Hh1P3W4tpB6COzTZiR59SP7luEevyozQg=";
  };

  vendorHash = "sha256-c1gf1qrxZ2rjB4GOh214vrtFBVo5nHJj5tesdiJxbjw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/plumber-cd/terraform-backend-git/cmd.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd terraform-backend-git \
      --bash <($out/bin/terraform-backend-git completion bash) \
      --fish <($out/bin/terraform-backend-git completion fish) \
      --zsh <($out/bin/terraform-backend-git completion zsh)
  '';

  meta = {
    description = "Terraform HTTP Backend implementation that uses Git repository as storage";
    mainProgram = "terraform-backend-git";
    homepage = "https://github.com/plumber-cd/terraform-backend-git";
    changelog = "https://github.com/plumber-cd/terraform-backend-git/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
