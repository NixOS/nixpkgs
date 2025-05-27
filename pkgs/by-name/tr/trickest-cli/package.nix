{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trickest-cli";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "trickest";
    repo = "trickest-cli";
    tag = "v${version}";
    hash = "sha256-EyUeYlWQWCGmCoQpuYXa9h93rXmTRmtSqIDrQRrTQgA=";
  };

  vendorHash = "sha256-Ae0fNzYOAeCMrNFVhw4VvG/BkOMcguIMiBvLGt7wxEo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI tool to execute Trickest workflows";
    homepage = "https://github.com/trickest/trickest-cli";
    changelog = "https://github.com/trickest/trickest-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "trickest";
  };
}
