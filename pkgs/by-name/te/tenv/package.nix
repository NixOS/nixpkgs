{ buildGoModule, fetchFromGitHub, installShellFiles, lib, tenv, testers }:

buildGoModule rec {
  pname = "tenv";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    rev = "v${version}";
    hash = "sha256-h380ZkVZS2NOTJvaxfqd2O5WEai0raFENqJQACC1Qtg=";
  };

  vendorHash = "sha256-BHr8n7GJmNV3kDYqVjpjGVNctIGsWh/UzAh0u8WSESs=";

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
