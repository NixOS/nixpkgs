{
  lib,
  # Breaks with go 1.24 (see https://github.com/gruntwork-io/terragrunt/issues/4031)
  # > 2025/03/17 13:30:44 internal error: package "bufio" without types was imported from "github.com/gruntwork-io/terragrunt/tf/getproviders"
  # > tf/getproviders/lock.go:1: running "mockery": exit status 1
  # > make: *** [Makefile:54: generate-mocks] Error 1
  buildGo123Module,
  fetchFromGitHub,
  go-mockery,
}:

buildGo123Module rec {
  pname = "terragrunt";
  version = "0.75.10";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-lnp1prffufVOG+XV7UAo9Rh3ALE//b87ioPgimgZ5S0=";
  };

  nativeBuildInputs = [ go-mockery ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-UhOb1Djup9Cwrv9vYeD/DZe20dwSKYRpJa4V3ZCsPwQ=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${version}"
    "-extldflags '-static'"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terragrunt --help
    $out/bin/terragrunt --version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${version}";
    description = "Thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    mainProgram = "terragrunt";
    license = licenses.mit;
    maintainers = with maintainers; [
      jk
      qjoly
      kashw2
    ];
  };
}
