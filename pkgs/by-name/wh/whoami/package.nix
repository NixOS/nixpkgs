{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "whoami";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "whoami";
    rev = "v${version}";
    hash = "sha256-wzxgmysqn4aWAZEaMjMwHdHLe4UZ4nwdNFJw5X7fuKQ=";
  };

  vendorHash = "sha256-qDfkYIAymkFUtbKka9OLoYjT+S9KhOra2UtOvhoz5Mw=";

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
