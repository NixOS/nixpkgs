{ lib, fetchFromGitHub }:
rec {
  version = "1.5.35";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-pzujKBUNVILFrgsCWuYFvO48AYPbBpxS1im1dj7NpMw=";
  };

  yarnHash = "sha256-P8TqHa5t3oWEYUQDD7VrGTWHJ3y68OhQa3YzQpceJgw=";

  meta = {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
