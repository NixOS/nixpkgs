{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "taskchampion-sync-server";
  version = "0.4.1-unstable-2024-04-08";
  src = fetchFromGitHub {
      owner = "GothenburgBitFactory";
      repo = "taskchampion-sync-server";
      rev = "31cb732f0697208ef9a8d325a79688612087185a";
      fetchSubmodules = false;
      sha256 = "sha256-CUgXJcrCOenbw9ZDFBody5FAvpT1dsZBojJk3wOv9U4=";
    };

  cargoHash = "sha256-TpShnVQ2eFNLXJzOTlWVaLqT56YkP4zCGCf3yVtNcvI=";

  # cargo tests fail when checkType="release" (default)
  checkType = "debug";

  meta = {
    description = "Sync server for Taskwarrior 3";
    license = lib.licenses.mit;
    homepage = "https://github.com/GothenburgBitFactory/taskchampion-sync-server";
    maintainers = with lib.maintainers; [mlaradji];
    mainProgram = "taskchampion-sync-server";
  };
}
