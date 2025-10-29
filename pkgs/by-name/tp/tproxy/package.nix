{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tproxy";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "kevwan";
    repo = "tproxy";
    tag = "v${version}";
    hash = "sha256-Ck7WtCxWiZxkKlx7D/N0EZmFEgrW7MpPj5ATvJxGXgg=";
  };

  vendorHash = "sha256-xYPF3RGrOQ1e2EPHtvlM9QKSE+V4cnG8f9JTS0hkAYU=";

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
