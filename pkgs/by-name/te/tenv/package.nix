{ buildGoModule, fetchFromGitHub, installShellFiles, lib, tenv, testers }:

buildGoModule rec {
  pname = "tenv";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    rev = "v${version}";
    hash = "sha256-LjgcI3E6K6b8fca9HdLyyIJJMHFxRtHdvWQb19jFHpA=";
  };

  vendorHash = "sha256-teog4VJGDOYsABuE2/fvOtcWvC8mM36rJQI6KZb3eS8=";

  # Tests disabled for requiring network access to release.hashicorp.com
  doCheck = false;

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd tenv \
      --zsh <($out/bin/tenv completion zsh) \
      --bash <($out/bin/tenv completion bash) \
      --fish <($out/bin/tenv completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    command = "HOME=$TMPDIR tenv --version";
    package = tenv;
    version = "v${version}";
  };

  meta = {
    changelog = "https://github.com/tofuutils/tenv/releases/tag/v${version}";
    description = "A version manager for OpenTofu, Terraform and Terragrunt written in Go";
    homepage = "https://github.com/tofuutils/tenv";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rmgpinto ];
  };
}
