{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tproxy";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "kevwan";
    repo = "tproxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-LX3ciC3cMYuQPm6ekEkJPrSdTXH+WZ4flXyrsvJZgn8=";
  };

  vendorHash = "sha256-7s2gnd9UR/R7H5pcA8NcoenaabSVpMh3qzzkOr5RWnU=";

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
