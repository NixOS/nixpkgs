{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terracognita";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = "terracognita";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pPY8y+pQdk9/F7dnUBz/y4lvcR1k/EClywcZATArZVA=";
  };

  vendorHash = "sha256-ApnJH0uIClXbfXK+k4t9Tcayc2mfndoG9iMqZY3iWys=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cycloidio/terracognita/cmd.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    mainProgram = "terracognita";
    homepage = "https://github.com/cycloidio/terracognita";
    changelog = "https://github.com/cycloidio/terracognita/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
