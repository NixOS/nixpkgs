{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  terraform-inventory,
}:

buildGoModule rec {
  pname = "terraform-inventory";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "adammck";
    repo = "terraform-inventory";
    rev = "v${version}";
    sha256 = "sha256-gkSDxcBoYmCBzkO8y1WKcRtZdfl8w5qVix0zbyb4Myo=";
  };

  vendorHash = "sha256-pj9XLzaGU1PuNnpTL/7XaKJZUymX+i8hFMroZtHIqTc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.build_version=${version}"
  ];

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = terraform-inventory;
  };

  meta = with lib; {
    homepage = "https://github.com/adammck/terraform-inventory";
    description = "Terraform state to ansible inventory adapter";
    mainProgram = "terraform-inventory";
    license = licenses.mit;
    maintainers = with maintainers; [ htr ];
  };
}
