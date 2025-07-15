{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.19.9";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = "terrascan";
    tag = "v${version}";
    hash = "sha256-4XIhmUUOSROwEPSB+DcMOfG5+q/pmWkVUwKGrWVcNtM=";
  };

  vendorHash = "sha256-yQien8v7Ru+JWLou9QfyKZAR2ENMHO2aF2vzuWyQcjY=";

  ldflags = [
    # Fix protobuf errors https://github.com/tenable/terrascan/pull/1703/files
    "-X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=ignore"
  ];

  # Tests want to download a vulnerable Terraform project
  doCheck = false;

  meta = {
    description = "Detect compliance and security violations across Infrastructure";
    mainProgram = "terrascan";
    longDescription = ''
      Detect compliance and security violations across Infrastructure as Code to
      mitigate risk before provisioning cloud native infrastructure. It contains
      500+ polices and support for Terraform and Kubernetes.
    '';
    homepage = "https://github.com/accurics/terrascan";
    changelog = "https://github.com/tenable/terrascan/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
