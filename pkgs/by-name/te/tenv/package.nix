{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  tenv,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "tenv";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3KSJG2gKnyu0Kxhbjemw4y8OvmXUNrqzlKcU9CCIqEo=";
  };

  vendorHash = "sha256-9A51pB94+PQP0SaT7LW78bwndGa5gOZOFkDEz2VzHl8=";

  excludedPackages = [ "tools" ];

  # Tests disabled for requiring network access to release.hashicorp.com
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tenv \
      --zsh <($out/bin/tenv completion zsh) \
      --bash <($out/bin/tenv completion bash) \
      --fish <($out/bin/tenv completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    command = "HOME=$TMPDIR tenv --version";
    package = tenv;
    version = "v${finalAttrs.version}";
  };

  meta = {
    changelog = "https://github.com/tofuutils/tenv/releases/tag/v${finalAttrs.version}";
    description = "OpenTofu, Terraform, Terragrunt and Atmos version manager written in Go";
    homepage = "https://tofuutils.github.io/tenv";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nmishin
      kvendingoldo
    ];
  };
})
