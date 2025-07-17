{ lib, fetchFromGitHub }:
rec {
  version = "1.5.34";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-PnC1Z4UtHqfQOenNIQpxcRysD4Hpb/WfjDe0OZP/k+0=";
  };

  yarnHash = "sha256-IVCT1KUhShCXY5ocmOul7DMzTe6ULm32azFE8HES1vc=";

  meta = {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
