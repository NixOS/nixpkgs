{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "taskchampion-sync-server";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskchampion-sync-server";
    tag = "v${version}";
    hash = "sha256-spuTCRsF1uHTTWfOjkMRokZnBhqP53CPAi3WMJB3yq4=";
  };

  cargoHash = "sha256-bsB/dPqPmzviHsGA8gtSew2PQdySNzifZ6dhu7XQ8IU=";

  meta = {
    description = "Sync server for Taskwarrior 3";
    license = lib.licenses.mit;
    homepage = "https://github.com/GothenburgBitFactory/taskchampion-sync-server";
    maintainers = with lib.maintainers; [ mlaradji ];
    mainProgram = "taskchampion-sync-server";
  };
}
