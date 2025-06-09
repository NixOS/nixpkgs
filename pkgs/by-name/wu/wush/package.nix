{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.4.1";
in
buildGoModule {
  pname = "wush";
  inherit version;

  src = fetchFromGitHub {
    owner = "coder";
    repo = "wush";
    rev = "v${version}";
    hash = "sha256-K83peIfr1+OHuuq6gdgco0RhfF1tAAewb4pxNT6vV+w=";
  };

  vendorHash = "sha256-3/DDtqVj7NNoJlNmKC+Q+XGS182E9OYkKMZ/2viANNQ=";

  ldflags = [
    "-s -w -X main.version=${version}"
  ];

  env.CGO_ENABLED = 0;

  meta = {
    homepage = "https://github.com/coder/wush";
    description = "Transfer files between computers via WireGuard";
    changelog = "https://github.com/coder/wush/releases/tag/v${version}";
    license = lib.licenses.cc0;
    mainProgram = "wush";
    maintainers = with lib.maintainers; [ abbe ];
  };
}
