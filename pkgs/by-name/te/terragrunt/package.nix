{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  go-mockery,
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.77.7";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-LP6qy0IAO/vD4eDTX6bgUe5mpL3ao+R4wwVNjBsaXhI=";
  };

  nativeBuildInputs = [
    versionCheckHook
    go-mockery
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-dxpb3tzVBlsZM6kAEvCVWxXVsuh6fkfxz0GpArtAi7g=";

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
