{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "tparse";
  version = "0.18.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mfridman";
    repo = "tparse";
    rev = "v${version}";
    hash = "sha256-oJApKmdo8uvnm6npXpzcKBRRkZ901AH1kZqGuoLdB3U=";
  };

  vendorHash = "sha256-4W6RryyQByUcwM2P2jmG2wXjNMrnpcCTSOJiw1M/Kd0=";

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
