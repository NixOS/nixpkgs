{ lib
, buildGoModule
, fetchFromGitHub
, go-mockery
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.62.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vubx/8rnUyOtQwykbFT8s/gAhuPorQtmkLJiiGu/pQY=";
  };

  nativeBuildInputs = [ go-mockery ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-1znEc/WmD3sCUqWxIvV0AdruxpUG7jh2IqTkGGak1VM=";

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
