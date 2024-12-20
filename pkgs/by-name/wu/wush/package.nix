{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.4.0";
in
buildGoModule {
  pname = "wush";
  inherit version;

  src = fetchFromGitHub {
    owner = "coder";
    repo = "wush";
    rev = "v${version}";
    hash = "sha256-0yICcexo5OZ7iNuZaKzWcWjZ34dY24GPosXIz9WlbK8=";
  };

  vendorHash = "sha256-LVqj27e2OcF+XBb6glTV5Zrw3W/vbtG7D7TmjcMQcnw=";

  ldflags = [
    "-s -w -X main.version=${version}"
  ];

  env.CGO_ENABLED = 0;

  meta = with lib; {
    homepage = "https://github.com/coder/wush";
    description = "Transfer files between computers via WireGuard";
    changelog = "https://github.com/coder/wush/releases/tag/v${version}";
    license = licenses.cc0;
    mainProgram = "wush";
    maintainers = with maintainers; [ abbe ];
  };
}
