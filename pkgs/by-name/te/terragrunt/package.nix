{ lib
, buildGoModule
, fetchFromGitHub
, go-mockery
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.67.3";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-OYtPpy3ig5NMw1Usmi7VnZyqr0hzG71/5R4qOEczZ4Y=";
  };

  nativeBuildInputs = [ go-mockery ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-NERvQoxT01ew/rCkEXrthsqF1mXjhxZANBL9ApTyd7o=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${version}"
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
    maintainers = with maintainers; [ jk qjoly kashw2 ];
  };
}
