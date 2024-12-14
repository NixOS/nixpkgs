{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-XXTa/FtvxXU34avQA+ykJjBRndMaOYTJDlJLbqzFqvM=";
  };

  vendorHash = "sha256-kXVNJgaA2Oon0+fTxk4WtN3P4PlaQszbaXEvSyS2lWU=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.BuildVersion=${version}"
    "-X"
    "main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
}
