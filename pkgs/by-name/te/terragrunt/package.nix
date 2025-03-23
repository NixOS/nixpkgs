{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  go-mockery,
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.76.1";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-VYoqKowP7LivXTifl0Qv3OnVyaIhhuA28jrvkaLSPFA=";
  };

  nativeBuildInputs = [
    versionCheckHook
    go-mockery
  ];

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
