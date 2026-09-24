{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "workstyle";
  version = "0-unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "pierrechevalier83";
    repo = "workstyle";
    rev = "dae15018c84c4f0feaf498d3676271ca0e3bec44";
    hash = "sha256-YcAn2oIVegAHa/mpqryRR1OIIAoJvCv+IiHB7s5mZOY=";
  };

  cargoHash = "sha256-ZGOjfWqPATvDU81BYXX+KF6uTD8hjKCOVLIHn/Kd3Ks=";

  meta = {
    description = "Sway workspaces with style";
    homepage = "https://github.com/pierrechevalier83/workstyle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    mainProgram = "workstyle";
  };
}
