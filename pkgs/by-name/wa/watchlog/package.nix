{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchlog";
  version = "1.250.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${version}";
    hash = "sha256-a8x1fEYuHZu2Z/CE835HEqkNr7Mtbdtuq1vDRKfEl5U=";
  };

  cargoHash = "sha256-b+xuMUt9btrfKLUluxtSFXdFKtOHmKVV0m1fPM5cNRA=";

  meta = {
    description = "Easier monitoring of live logs";
    homepage = "https://gitlab.com/kevincox/watchlog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kevincox ];

    # Dependency only supports Linux + Windows: https://github.com/mentaljam/standard_paths/tree/master/src
    platforms = with lib.platforms; linux ++ windows;
    mainProgram = "wl";
  };
}
