{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "taskchampion-sync-server";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskchampion-sync-server";
    tag = "v${version}";
    hash = "sha256-uOlubcQ5LAECvQEqgUR/5aLuDGQrdHy+K6vSapACmoo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BOXg6Pjy4lhzdaqJkOLJNGAtX9cWmbN6QEmP0g7D6Qw=";

  meta = {
    description = "Sync server for Taskwarrior 3";
    license = lib.licenses.mit;
    homepage = "https://github.com/GothenburgBitFactory/taskchampion-sync-server";
    maintainers = with lib.maintainers; [ mlaradji ];
    mainProgram = "taskchampion-sync-server";
  };
}
