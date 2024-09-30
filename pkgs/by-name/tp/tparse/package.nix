{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "tparse";
  version = "0.15.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mfridman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CxoVu3WH2I/1wT5o/RGIrGFrGCQOC4vcUKMiH/Gv3aY=";
  };

  vendorHash = "sha256-soIti6o8BUnarPf5/bcMJKdEG0oRpDLMkQM6RlbZQ5I=";

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
