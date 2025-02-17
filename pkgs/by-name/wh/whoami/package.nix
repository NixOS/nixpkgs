{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "whoami";
  version = "1.10.4";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "whoami";
    rev = "v${version}";
    hash = "sha256-T5oUIJ6ELfPNd8JW5hUXV6bRUGVRD0IgHJ34ioR4sMs=";
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
