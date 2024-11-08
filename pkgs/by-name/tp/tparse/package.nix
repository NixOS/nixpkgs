{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "tparse";
  version = "0.16.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mfridman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fljSjch09kQCpnZerI/h4SRCyxUydfFZGyOXsxmgYOk=";
  };

  vendorHash = "sha256-gGmPQ8YaTk7xG5B8UPK7vOui5YFeEnkuGrAsf0eylXQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "CLI tool for summarizing go test output. Pipe friendly. CI/CD friendly";
    mainProgram = "tparse";
    homepage = "https://github.com/mfridman/tparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ obreitwi ];
  };
}
