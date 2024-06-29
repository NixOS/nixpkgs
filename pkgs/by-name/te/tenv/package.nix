{ buildGoModule, fetchFromGitHub, installShellFiles, lib, tenv, testers }:

buildGoModule rec {
  pname = "tenv";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    rev = "v${version}";
    hash = "sha256-9wY+9lAbrnwiXpLilMaqtQz0XmMGRMv+m+yR7BxmSsw=";
  };

  vendorHash = "sha256-v1NWlZhfypoS+bZCtr+P2s1t4qYVncbjx9IyRhi2sa4=";

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
    description = "OpenTofu, Terraform, Terragrunt and Atmos version manager written in Go";
    homepage = "https://tofuutils.github.io/tenv";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rmgpinto nmishin kvendingoldo ];
  };
}
