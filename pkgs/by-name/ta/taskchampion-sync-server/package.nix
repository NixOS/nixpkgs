{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "taskchampion-sync-server";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskchampion-sync-server";
    tag = "v${version}";
    hash = "sha256-Icw4qhYBehoKBV/8Qg79SOyfGC7nf0j16FvFsGCgakE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HD73UN5gqSyf4u4Rp6TF+Gl44Rw69CG877e0rWqhF9w=";

  meta = {
    description = "Sync server for Taskwarrior 3";
    license = lib.licenses.mit;
    homepage = "https://github.com/GothenburgBitFactory/taskchampion-sync-server";
    maintainers = with lib.maintainers; [ mlaradji ];
    mainProgram = "taskchampion-sync-server";
  };
}
