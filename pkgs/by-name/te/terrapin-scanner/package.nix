{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrapin-scanner";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "RUB-NDS";
    repo = "Terrapin-Scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-snKEIWhFj+uG/jY1nbq/8T0y2FcAdkIUTf9J2Lz6owo=";
  };

  vendorHash = null;

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
