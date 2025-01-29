{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-mockery,
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.72.2";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-SX7y4YLKehyz0vutNDWCBF9w20xW1EuDBaAkqENNTJ0=";
  };

  nativeBuildInputs = [ go-mockery ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-a+nsbgAUgC7d8Nqexzubbx9CqK3o+TJbO+FJH3Fr2Js=";

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
