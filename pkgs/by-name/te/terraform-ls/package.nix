{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.36.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-ls";
    rev = "v${version}";
    hash = "sha256-oSrv0Ct60nN2AVihtcQcIWVpLFDra2Jv3bjjlM6pn9E=";
  };

  vendorHash = "sha256-Q2a6rCyx59cRaUBTzkKH6OgB9DRlkQSTgAI7WKDCbCI=";

  ldflags = [
    "-s"
    "-w"
  ];

  # There's a mixture of tests that use networking and several that fail on aarch64
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terraform-ls --help
    $out/bin/terraform-ls --version | grep "${version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "Terraform Language Server (official)";
    mainProgram = "terraform-ls";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      mbaillie
      jk
    ];
  };
}
