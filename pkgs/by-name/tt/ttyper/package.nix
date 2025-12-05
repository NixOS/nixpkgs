{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = "ttyper";
    rev = "v${version}";
    hash = "sha256-g4OD4Mc3KHN9rrzM+9JvN2xTnSojGQy6yptdGj3zgW4=";
  };

  cargoHash = "sha256-M8LG/rZLFRUztniCmUuyj5mdzH3qUKoj02uUQ2zlq8M=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      max-niederman
    ];
    mainProgram = "ttyper";
  };
}
