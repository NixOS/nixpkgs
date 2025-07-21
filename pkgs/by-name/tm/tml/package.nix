{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tml";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "tml";
    rev = "v${version}";
    hash = "sha256-QMXEKjOKYQlzXc2ds8OAAL5xUxayGb6mxxyeHsCkfwo=";
  };

  vendorHash = "sha256-CHZS1SpPko8u3tZAYbf+Di882W55X9Q/zd4SmFCRgKM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tiny markup language for terminal output";
    mainProgram = "tml";
    homepage = "https://github.com/liamg/tml";
    changelog = "https://github.com/liamg/tml/releases/tag/v${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
