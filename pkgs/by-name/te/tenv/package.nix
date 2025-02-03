{ buildGoModule, fetchFromGitHub, installShellFiles, lib, tenv, testers }:

buildGoModule rec {
  pname = "tenv";
  version = "2.7.9";

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    rev = "v${version}";
    hash = "sha256-oeMbpnYCkJ5GjfgOlNyQpwy80DbrupXIFS2dx4W2xo4=";
  };

  vendorHash = "sha256-/4RiOF9YU4GEZlJcx2S2bLhJ1Q6F+8To3XiyWzGGHUU=";

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
