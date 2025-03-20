{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "whoami";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "whoami";
    rev = "v${version}";
    hash = "sha256-3jzLdCmmts/7S1Oxig9Dg3kRGh/H5l5UD7ztev0yvXY=";
  };

  vendorHash = "sha256-0Qxw+MUYVgzgWB8vi3HBYtVXSq/btfh4ZfV/m1chNrA=";

  ldflags = [ "-s" ];

  env.CGO_ENABLED = 0;

  doCheck = false;

  meta = {
    description = "Tiny Go server that prints os information and HTTP request to output";
    mainProgram = "whoami";
    homepage = "https://github.com/traefik/whoami";
    changelog = "https://github.com/traefik/whoami/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dvcorreia ];
  };
}
