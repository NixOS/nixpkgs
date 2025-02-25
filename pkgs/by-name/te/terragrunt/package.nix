{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-mockery,
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.73.12";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-nuqulBONUMY0BNh5uhhRGJruZdnkY05dd7zcX4t0MjE=";
  };

  nativeBuildInputs = [ go-mockery ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-EO3zgqVqf994xB55twRmcGBQdffrNr2BejNq2jlkMSA=";

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
