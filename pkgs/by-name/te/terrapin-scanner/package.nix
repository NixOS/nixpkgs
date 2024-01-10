{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrapin-scanner";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "RUB-NDS";
    repo = "Terrapin-Scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-LBcoD/adIcda6ZxlEog8ArW0thr3g14fvEMFfgxiTsI=";
  };

  vendorHash = "sha256-x3fzs/TNGRo+u+RufXzzjDCeQayEZIKlgokdEQJRNaI=";

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
