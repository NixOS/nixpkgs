{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.2.1";
in
buildGoModule {
  pname = "wush";
  inherit version;

  src = fetchFromGitHub {
    owner = "coder";
    repo = "wush";
    rev = "v${version}";
    hash = "sha256-kxynXymCz3cLEeeINT72Xl8TOEAFyB4Z3y5WNtARnSI=";
  };

  vendorHash = "sha256-g3QqXII9nI5+wBa2YyTajz15Bx1F5/6PV9oNlbcZbe4=";

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
