{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "tparse";
  version = "0.17.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mfridman";
    repo = "tparse";
    rev = "v${version}";
    hash = "sha256-yU4hP+EJ+Ci3Ms0dAoSuqZFT9RRwqmN1V0x5cV+87z0=";
  };

  vendorHash = "sha256-m0YTGzzjr7/4+vTNhfPb7y2xtsI/y4Q2pbg+3yqSFaw=";

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
