{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "udpx";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "nullt3r";
    repo = "udpx";
    tag = "v${version}";
    hash = "sha256-IRnGi3TmCyxmJKAd8ZVRoSHDao+3Xt4F5QfHvNahvGo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Single-packet UDP scanner";
    mainProgram = "udpx";
    homepage = "https://github.com/nullt3r/udpx";
    changelog = "https://github.com/nullt3r/udpx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
