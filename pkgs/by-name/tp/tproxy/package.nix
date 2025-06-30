{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tproxy";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kevwan";
    repo = "tproxy";
    tag = "v${version}";
    hash = "sha256-LiYZ9S7Jga4dQWHmqsPvlGDAAw5reO16LAYaNJZFnhE=";
  };

  vendorHash = "sha256-YjkYb5copw0SM2lago+DyVgHIrqLDSBnO+4zLMq+YJ8=";

  ldflags = [
    "-w"
    "-s"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to proxy and analyze TCP connections";
    homepage = "https://github.com/kevwan/tproxy";
    changelog = "https://github.com/kevwan/tproxy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DCsunset ];
    mainProgram = "tproxy";
  };
}
