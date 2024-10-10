{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "taskchampion-sync-server";
  version = "0.4.1-unstable-2024-08-20";
  src = fetchFromGitHub {
      owner = "GothenburgBitFactory";
      repo = "taskchampion-sync-server";
      rev = "af918bdf0dea7f7b6e920680c947fc37b37ffffb";
      fetchSubmodules = false;
      hash = "sha256-BTGD7hZysmOlsT2W+gqj8+Sj6iBN9Jwiyzq5D03PDzM=";
    };

  cargoHash = "sha256-/HfkE+R8JoNGkCCNQpE/JjGSqPHvjCPnTjOFPCFfJ7A=";

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
