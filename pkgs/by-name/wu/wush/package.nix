{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.3.0";
in
buildGoModule {
  pname = "wush";
  inherit version;

  src = fetchFromGitHub {
    owner = "coder";
    repo = "wush";
    rev = "v${version}";
    hash = "sha256-2mFe1p15HRyy86pw5LoBtiW9lKrw/N9V81/jkiT4jo4=";
  };

  vendorHash = "sha256-Po1DDKP9ekScRDGMjCXZr9HUUwFenQx3bzIZrNI+ctY=";

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
