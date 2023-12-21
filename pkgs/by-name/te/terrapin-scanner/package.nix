{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrapin-scanner";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "RUB-NDS";
    repo = "Terrapin-Scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-d0aAs9dT74YQkzDQnmeEo+p/RnPHeG2+SgCCF/t1F+w=";
  };

  vendorHash = "sha256-skYMlL9SbBoC89tFCTIzyRViEJaviXENASEqr6zSvoo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Vulnerability scanner for the Terrapin attack";
    homepage = "https://github.com/RUB-NDS/Terrapin-Scanner";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "Terrapin-Scanner";
  };
}
