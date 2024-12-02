{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tf2pulumi";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "tf2pulumi";
    rev = "v${version}";
    sha256 = "sha256-i6nK1AEnQY47ro6tNDBExdcb9WvltY/21FVrVaiSTvo=";
  };

  vendorHash = "sha256-x7GAkbvhML2VUQ9/zitrTBBiy9lISb3iTx6yn5WbEig=";

  ldflags = [
    "-s" "-w" "-X=github.com/pulumi/tf2pulumi/version.Version=${src.rev}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert Terraform projects to Pulumi TypeScript programs";
    mainProgram = "tf2pulumi";
    homepage = "https://www.pulumi.com/tf2pulumi/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
