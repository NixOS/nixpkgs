{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.1.2";
in
buildGoModule {
  pname = "wush";
  inherit version;

  src = fetchFromGitHub {
    owner = "coder";
    repo = "wush";
    rev = "v${version}";
    hash = "sha256-r6LKEL9GxyiyQgM4AuLU/FcmYKOCg7EZDmAZQznCx8E=";
  };

  vendorHash = "sha256-e1XcoiJ55UoSNFUto6QM8HrQkkrBf8sv4L9J+7Lnu2I=";

  ldflags = [
    "-s -w -X main.version=${version}"
  ];

  CGO_ENABLED = 0;

  meta = with lib; {
    homepage = "https://github.com/coder/wush";
    description = "Transfer files between computers via WireGuard";
    changelog = "https://github.com/coder/wush/releases/tag/v${version}";
    license = licenses.cc0;
    mainProgram = "wush";
    maintainers = with maintainers; [ abbe ];
  };
}
